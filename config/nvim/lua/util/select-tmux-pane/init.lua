local list = require("util.select-tmux-pane.list-and-sort")

local function pane_label(entry)
  if type(entry) == "string" then
    return entry
  end
  if type(entry) ~= "table" then
    return tostring(entry)
  end
  return string.format(
    "%s session=%s window=%s:%s pid=%s path=%s",
    entry.pane_id or "?",
    entry.session_name or "?",
    entry.window_index or "?",
    entry.pane_index or "?",
    entry.pane_pid or "?",
    entry.pane_current_path or "?"
  )
end

local function pane_id_from_entry(entry)
  if type(entry) == "string" then
    return entry:match("^(%%%d+)")
  end
  if type(entry) == "table" and type(entry.pane_id) == "string" then
    return entry.pane_id:match("^(%%%d+)")
  end
  return nil
end

local function select_inputlist_tmux_pane(entries)
  if not entries or vim.tbl_isempty(entries) then
    return nil
  end

  -- FIXME: Opening Telescope from workflow prompt content can freeze chat startup.
  -- Keep this synchronous selector in-workflow. If Telescope+preview is required,
  -- split pane selection into a separate user command before starting the workflow.
  local menu = { "Select tmux pane to watch (0 to cancel):" }
  for i, entry in ipairs(entries) do
    table.insert(menu, string.format("%d. %s", i, pane_label(entry)))
  end
  local idx = vim.fn.inputlist(menu)
  local selected = (idx > 0 and idx <= #entries) and entries[idx] or nil

  if not selected then
    return nil
  end
  return pane_id_from_entry(selected)
end

local function pick_tmux_pane_telescope(entries, on_select)
  local has_telescope, pickers = pcall(require, "telescope.pickers")
  if not has_telescope then
    local pane_id = select_inputlist_tmux_pane(entries)
    if pane_id then
      on_select(pane_id)
    end
    return
  end

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local previewers = require("telescope.previewers")

  pickers
    .new({}, {
      prompt_title = "CodeCompanionTmuxWorkflow",
      finder = finders.new_table({
        results = entries,
        entry_maker = function(entry)
          local label = pane_label(entry)
          return {
            value = entry,
            display = label,
            ordinal = label,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = previewers.new_termopen_previewer({
        title = "capture-pane",
        get_command = function(entry)
          local pane_id = pane_id_from_entry(entry and entry.value or entry)
          if not pane_id then
            return { "sh", "-c", "printf '%s\n' 'No pane selected.'" }
          end
          -- `-e` keeps ANSI escapes so the terminal preview renders colors.
          local cmd = string.format("tmux capture-pane -e -p -S -50 -t %s", vim.fn.shellescape(pane_id))
          return { "sh", "-c", cmd }
        end,
      }),
      attach_mappings = function(prompt_bufnr, _)
        local resolved = false
        local function resolve(pane_id)
          if resolved then
            return
          end
          resolved = true
          on_select(pane_id)
        end

        actions.select_default:replace(function()
          local item = action_state.get_selected_entry()
          if not item then
            actions.close(prompt_bufnr)
            return
          end
          local pane_id = pane_id_from_entry(item.value or item)
          resolve(pane_id)
          actions.close(prompt_bufnr)
        end)
        actions.close:enhance({
          post = function()
            resolve(nil)
          end,
        })
        return true
      end,
    })
    :find()
end

---@param on_select fun(pane_id: string|nil)
local function select_tmux_pane_async(on_select)
  local listed = list.list_tmux_pane_with_rank()
  pick_tmux_pane_telescope(listed, on_select)
end

---@return string|nil
local function select_tmux_pane()
  local listed = list.list_tmux_pane_with_rank()
  return select_inputlist_tmux_pane(listed)
end

return {
  select_tmux_pane_async = select_tmux_pane_async,
  select_tmux_pane = select_tmux_pane,
}
