local TmuxWorkflowUserPrompt = {
  ---@param user_prompt string
  ---@return string pane_id
  ---@return string task
  parse = function(user_prompt)
    local prompt = user_prompt or ""
    local pane_id = prompt:match("pane_id=(%%%d+)")
    local task = prompt:match("task=(.-)\n?$")
    if task == "" then
      task = nil
    end
    return pane_id, task
  end,
  gen = function(pane_id, task)
    local user_prompt = string.format("pane_id=%s\ntask=%s", pane_id, task)
    return user_prompt
  end,
}

local function get_tmux_executing_commands()
  local cmd =
    [[tmux list-panes -a -F '#{pane_id} #{pane_pid}' | while read pane pid; do ps -o cmd= --ppid "$pid" | sed "s/^/$pane /"; done]]
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return {}
  end
  return lines
end

local function make_tmux_watch_prompt(context)
  local entries = get_tmux_executing_commands()
  if vim.tbl_isempty(entries) then
    return [[No tmux child process was found.
Please start a task in a tmux pane first, then run this workflow again.]]
  end

  local pane_id, task = TmuxWorkflowUserPrompt.parse(context and context.user_prompt or nil)
  if not pane_id then
    pane_id = require("util.select-tmux-pane").select_tmux_pane()
  end
  if not pane_id then
    return [[Pane selection was canceled. Stop this workflow now.]]
  end
  if not task or task == "" then
    task = "<edit this in step 1>"
  end
  local project_root = vim.fn.getcwd()

  return string.format(
    [[Monitor tmux pane `%s` continuously.
Project root: `%s`
Task objective: %s
Agent: @{auto_agent}

Allowed tools: @{run_command}, @{read_file}, @{insert_edit_into_file}, @{get_changed_files}

Cycle command (run every cycle first):
`tmux capture-pane -p -S -80 -t %s`

  Execution loop:
  1) Read latest tmux output.
  2) Classify each failure before editing:
     - A) implementation defect (code does not match existing intended behavior)
     - B) spec ambiguity/conflict (multiple valid behaviors)
     - C) test issue (incorrect assertion, brittle test, or intentionally failing policy test)
  3) If A and fixable:
     - identify exact failing lines
     - read only relevant files
     - apply minimal edits that preserve current product intent
     - re-check tmux output
     - repeat
  4) If B or C:
     - do not silently change behavior to make tests pass
     - trigger confirmation gate (below) before any behavior-changing edit
  5) If output is insufficient/noisy, capture again before deciding.
  6) Do not stop at analysis when a concrete non-behavior-changing fix is possible.
  7) Keep scope tight; avoid unrelated edits/refactors.

  Behavior protection rules (strict):
  - Do NOT change business-rule precedence, decision policy, or externally visible behavior without explicit approval.
  - Do NOT convert an ambiguous-policy test into a passing test by picking one policy silently.
  - When a test description/comment says “requires spec decision / intentionally failing / policy conflict”, treat it as policy-sensitive and require confirmation
  before behavior edits.
  - Prefer preserving existing behavior and adjusting only clear defects (typos, null checks, wrong variable use, incorrect boundaries clearly contradicted by nearby
  tests/docs).

  Mandatory confirmation gate (pause and ask) before:
  - architecture changes
  - broad refactors across multiple modules
  - dependency add/remove/upgrade
  - destructive operations
  - any behavior/policy change (including rule precedence, status mapping, risk threshold, hard-rule overrides)
  - requirement reinterpretation with multiple valid meanings

  When asking, use exactly:
  1) Option A vs Option B (one-line trade-off each)
  2) Recommended option + reason (one line)
  3) `Proceed with option <X>?`

  Output discipline each cycle:
  - First line: `CLASSIFICATION: A|B|C`
  - Then 2-4 lines:
    - failing signal seen
    - chosen action
    - whether confirmation is required

  Completion rule:
  - Reply exactly `TMUX_WATCH_DONE` and stop only if:
    a) implementation defects are resolved within approved behavior boundaries, and
    b) no remaining actionable failures are visible in latest tmux output.
  - If failures remain, continue the loop (do not only summarize).
  - If only policy-sensitive ambiguity remains, ask via confirmation gate and continue monitoring.
]],
    pane_id,
    project_root,
    task,
    pane_id
  )
end

local M = {}
M.make_tmux_watch_prompt = make_tmux_watch_prompt

function M.start_tmux_workflow(task)
  local async = require("plenary.async")
  local select_tmux_pane_await = async.wrap(require("util.select-tmux-pane").select_tmux_pane_async, 1)

  async.run(function()
    local pane_id = select_tmux_pane_await()
    if not pane_id then
      vim.schedule(function()
        vim.notify("CodeCompanionTmuxWorkflow: pane selection canceled", vim.log.levels.INFO)
      end)
      return
    end

    local current_task = task
    if not current_task or current_task == "" then
      current_task = vim.fn.input("tmux workflow task: ")
    end
    local safe_task = current_task and current_task:gsub("\n", " ") or ""
    local user_prompt = TmuxWorkflowUserPrompt.gen(pane_id, safe_task)
    require("codecompanion").prompt("tmux_watch", {
      user_prompt = user_prompt,
    })
  end)
end

return M
