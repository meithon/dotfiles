local M = {}

-- type definition

---@alias Provider "openai" | "anthropic" | "azure" | "bing" | "chatgpt" | "cohere" | "databricks" | "deepai" | "deepset" | "gpt-4" | "gpt-4-0314" | "gpt-4-32k" | "gpt-4-32k-0314"

---@class AdapterNameAndModel
---@field name Provider
---@field model string

---@alias Adapter Provider | AdapterNameAndModel

-- class definition

local ConfigBuilder = {}
ConfigBuilder.__index = ConfigBuilder

function ConfigBuilder.new()
  local self = setmetatable({}, ConfigBuilder)
  self.opts = {}
  return self
end



-- local function select_tmux_pane(entries)
--   if not entries or vim.tbl_isempty(entries) then
--     return nil
--   end
--
--   -- FIXME: Opening Telescope from workflow prompt content can freeze chat startup.
--   -- Keep this synchronous selector in-workflow. If Telescope+preview is required,
--   -- split pane selection into a separate user command before starting the workflow.
--   local menu = { "Select tmux pane to watch (0 to cancel):" }
--   for i, line in ipairs(entries) do
--     table.insert(menu, string.format("%d. %s", i, line))
--   end
--   local idx = vim.fn.inputlist(menu)
--   local selected = (idx > 0 and idx <= #entries) and entries[idx] or nil
--
--   if not selected then
--     return nil
--   end
--   return selected:match("^(%%%d+)")
-- end



-- local function pick_tmux_pane_telescope(on_select)
--   local entries = get_tmux_executing_commands()
--   if vim.tbl_isempty(entries) then
--     vim.notify("No tmux child process was found", vim.log.levels.WARN)
--     return
--   end
--
--   local has_telescope, pickers = pcall(require, "telescope.pickers")
--   if not has_telescope then
--     local pane_id = select_tmux_pane(entries)
--     if pane_id then
--       on_select(pane_id)
--     end
--     return
--   end
--
--   local actions = require("telescope.actions")
--   local action_state = require("telescope.actions.state")
--   local conf = require("telescope.config").values
--   local finders = require("telescope.finders")
--   local previewers = require("telescope.previewers")
--
--   pickers
--     .new({}, {
--       prompt_title = "CodeCompanionTmuxWorkflow",
--       finder = finders.new_table({ results = entries }),
--       sorter = conf.generic_sorter({}),
--       previewer = previewers.new_termopen_previewer({
--         title = "capture-pane",
--         get_command = function(entry)
--           local value = entry.value or entry[1]
--           local pane_id = type(value) == "string" and value:match("^(%%%d+)") or nil
--           if not pane_id then
--             return { "sh", "-c", "printf '%s\n' 'No pane selected.'" }
--           end
--           -- `-e` keeps ANSI escapes so the terminal preview renders colors.
--           local cmd = string.format("tmux capture-pane -e -p -S -50 -t %s", vim.fn.shellescape(pane_id))
--           return { "sh", "-c", cmd }
--         end,
--       }),
--       attach_mappings = function(prompt_bufnr, _)
--         actions.select_default:replace(function()
--           local item = action_state.get_selected_entry()
--           actions.close(prompt_bufnr)
--           if not item then
--             return
--           end
--           local line = item.value or item[1]
--           local pane_id = type(line) == "string" and line:match("^(%%%d+)") or nil
--           if pane_id then
--             on_select(pane_id, line)
--           end
--         end)
--         return true
--       end,
--     })
--     :find()
-- end

function ConfigBuilder:_merge(new_opts)
  self.opts = vim.tbl_deep_extend("force", self.opts, new_opts)
  return self
end

-- public methods

function ConfigBuilder:extend_mcphub()
  return self:_merge({
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
  })
end

function ConfigBuilder:extend_history()
  return self:_merge({
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc",
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0,
          -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
          picker = "telescope",
          ---Automatically generate titles for new chats
          auto_generate_title = true,
          title_generation_opts = {
            ---Adapter for generating titles (defaults to current chat adapter)
            adapter = nil, -- "copilot"
            ---Model for generating titles (defaults to current chat model)
            model = nil, -- "gpt-4o"
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          ---Enable detailed logging for history extension
          enable_logging = false,
        },
      },
    },
  })
end

function ConfigBuilder:setup_general_option()
  return self:_merge({
    opts = {
      -- log_level = "TRACE", -- Set logging level (options: TRACE, DEBUG, INFO, ERROR)
      language = "Japanese", -- The language used for LLM responses

      auto_submit = true,
      -- If this is false then any default prompt that is marked as containing code
      -- will not be sent to the LLM. Please note that whilst I have made every
      -- effort to ensure no code leakage, using this is at your own risk
      ---@type boolean|function
      ---@return boolean
      send_code = true,

      -- job_start_delay = 1500, -- Delay in milliseconds between cmd tools
      -- submit_delay = 2000, -- Delay in milliseconds before auto-submitting the chat buffer

      ---This is the default prompt which is sent with every request in the chat
      ---strategy. It is primarily based on the GitHub Copilot Chat's prompt
      ---but with some modifications. You can choose to remove this via
      ---your own config but note that LLM results may not be as good
      ---@param opts table
      ---@return string
      system_prompt = function()
        local language = "Japanese"
        return string.format(
          [[You are an AI programming assistant named "CodeCompanion". You are currently plugged into the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
- Minimize additional prose unless clarification is needed.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of each Markdown code block.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.
- Use actual line breaks in your responses; only use "\n" when you want a literal backslash followed by 'n'.
- All non-code text responses must be written in the %s language indicated.
- Anticipate the next question at the end of the answer and state it in a NUMBER LIST

When given a task:
1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.
2. Output the final code in a single code block, ensuring that only relevant code is included.
3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.
4. Provide exactly one complete reply per conversation turn.
]],
          language
        )
      end,
    },
  })
end

---@param adapter Adapter
function ConfigBuilder:set_inline_adapter(adapter)
  return self:_merge({
    interactions = {
      inline = {
        adapter = adapter,
      },
    },
  })
end

function ConfigBuilder:set_inline_keybind()
  return self:_merge({
    interactions = {
      inline = {
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            description = "Reject the suggested change",
          },
        },
      },
    },
  })
end

function ConfigBuilder:add_prompt_library()
  return self:_merge({
    prompt_library = {

      -- Prefer buffer selection in chat instead of inline
      ["Buffer selection"] = {
        strategy = "chat",
        opts = {
          auto_submit = false,
        },
      },
      ["Generate a Commit Message for Staged Files"] = {
        strategy = "inline",
        description = "staged file commit messages",
        opts = {
          index = 15,
          is_default = false,
          is_slash_cmd = true,
          short_name = "scommit",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return "You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:"
                .. "\n\n```diff\n"
                .. vim.fn.system("git diff --staged")
                .. "\n```"
            end,
          },
        },
      },
      ["Add Documentation"] = {
        strategy = "inline",
        description = "Add documentation to the selected code",
        opts = {
          index = 16,
          is_default = false,
          modes = { "v" },
          short_name = "doc",
          is_slash_cmd = true,
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = "When asked to add documentation, follow these steps:\n"
              .. "1. **Identify Key Points**: Carefully read the provided code to understand its functionality.\n"
              .. "2. **Review the Documentation**: Ensure the documentation:\n"
              .. "  - Includes necessary explanations.\n"
              .. "  - Helps in understanding the code's functionality.\n"
              .. "  - Follows best practices for readability and maintainability.\n"
              .. "  - Is formatted correctly.\n\n"
              .. "For C/C++ code: use Doxygen comments using `\\` instead of `@`.\n"
              .. "For Python code: Use Docstring numpy-notypes format.",
            opts = {
              visible = false,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              return "Please document the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["Refactor"] = {
        strategy = "chat",
        description = "Refactor the selected code for readability, maintainability and performances",
        opts = {
          index = 17,
          is_default = false,
          modes = { "v" },
          short_name = "refactor",
          is_slash_cmd = true,
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = "When asked to optimize code, follow these steps:\n"
              .. "1. **Analyze the Code**: Understand the functionality and identify potential bottlenecks.\n"
              .. "2. **Implement the Optimization**: Apply the optimizations including best practices to the code.\n"
              .. "3. **Shorten the code**: Remove unnecessary code and refactor the code to be more concise.\n"
              .. "3. **Review the Optimized Code**: Ensure the code is optimized for performance and readability. Ensure the code:\n"
              .. "  - Maintains the original functionality.\n"
              .. "  - Is more efficient in terms of time and space complexity.\n"
              .. "  - Follows best practices for readability and maintainability.\n"
              .. "  - Is formatted correctly.\n\n"
              .. "Use Markdown formatting and include the programming language name at the start of the code block.",
            opts = {
              visible = false,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return "Please optimize the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["PullRequest"] = {
        strategy = "chat",
        description = "Generate a Pull Request message description",
        opts = {
          index = 18,
          is_default = false,
          short_name = "pr",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return "You are an expert at writing detailed and clear pull request descriptions."
                .. "Please create a pull request message following standard convention from the provided diff changes."
                .. "Ensure the title, description, type of change, checklist, related issues, and additional notes sections are well-structured and informative."
                .. "\n\n```diff\n"
                .. vim.fn.system("git diff $(git merge-base HEAD main)...HEAD")
                .. vim.fn.system("git diff $(git merge-base HEAD develop)...HEAD")
                .. "\n```"
            end,
          },
        },
      },
      ["Spell"] = {
        strategy = "inline",
        description = "Correct grammar and reformulate",
        opts = {
          index = 19,
          is_default = false,
          short_name = "spell",
          is_slash_cmd = true,
          auto_submit = true,
          adapter = {
            name = "copilot",
            model = "gpt-4.1",
          },
        },
        prompts = {
          {
            role = "user",
            contains_code = false,
            content = function(context)
              local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              return "Correct grammar and reformulate:\n\n" .. text
            end,
          },
        },
      },
      ["Bug Finder"] = {
        strategy = "chat",
        description = "Find potential bugs from the provided diff changes",
        opts = {
          index = 20,
          is_default = false,
          short_name = "bugs",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local question = "<question>\n"
                .. "Check if there is any bugs that have been introduced from the provided diff changes.\n"
                .. "Perform a complete analysis and do not stop at first issue found.\n"
                .. "If available, provide absolute file path and line number for code snippets.\n"
                .. "</question>"

              local branch = "$(git merge-base HEAD origin/develop)...HEAD"
              local changes = "changes.diff"
              vim.fn.system("git diff --unified=10000 " .. branch .. " > " .. changes)

              --- @type CodeCompanion.Chat
              local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
              local path = vim.fn.getcwd() .. "/" .. changes
              local id = "<file>" .. changes .. "</file>"
              local lines = vim.fn.readfile(path)
              local content = table.concat(lines, "\n")

              chat:add_message({
                role = "user",
                content = "git diff content from " .. path .. ":\n" .. content,
              }, { reference = id, visible = false })

              chat.context:add({
                id = id,
                path = path,
                source = "",
              })

              return question
            end,
          },
        },
      },
      ["Split Commits"] = {
        strategy = "chat",
        description = "agent mode with explicit set of tools",
        opts = {
          index = 21,
          is_default = false,
          short_name = "commits",
          is_slash_cmd = true,
          auto_submit = false,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
              local logs = vim.fn.system('git log --pretty=format:"%s%n%b" -n 50')
              local commit_history = "Commit history for branch " .. current_branch .. ":\n" .. logs .. "\n\n"
              local staged_changes = "Staged files:\n" .. vim.fn.system("git diff --cached --name-only")
              local prompt = "<prompt>" .. commit_history .. staged_changes .. "</prompt> \n\n"
              local task = "You are an expert Git assistant.\n"
                .. "Your task is to help the user create well-structured and conventional commits from their currently staged changes.\n\n"
                .. "Based on the provided commit logs and branch name, first, infer the established commit message convention\n"
                .. "Next, use the staged changes to determine the logical grouping of changes and generate appropriate commit messages.\n\n"
                .. "Your primary goal is to analyze these staged changes and determine if they should be split into multiple logical and separate commits.\n"
                .. "If the staged changes are empty or too trivial for a meaningful commit, please state that.\n\n"
                .. "Use @{cmd_runner} to execute git commands for staging and un-staging files to group staged changes into meaningful commits when necessary."
              return prompt .. task
            end,
          },
        },
      },
      ["Gitlab MR Notes"] = {
        strategy = "chat",
        description = "Get the unresolved comments of the current MR",
        opts = {
          index = 22,
          is_default = false,
          short_name = "glab_mr_notes",
          is_slash_cmd = true,
          auto_submit = false,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local notes = require("util.glab.notes").get_unresolved_discussions()
              return "Here is a list of notes from Pull Request:\n" .. notes .. "\n"
            end,
          },
        },
      },
      ["qflist"] = {
        strategy = "chat",
        description = "Send errors to qflist and diagnostics",
        opts = {
          index = 23,
          is_default = false,
          short_name = "qflist",
          is_slash_cmd = true,
          auto_submit = false,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local content =
                "Create a neovim command line for `:` to send the current errors to qflist and diagnostics using neovim api.\n"
              local example = [[
                :lua do local ns = vim.api.nvim_create_namespace('review');

                  -- For each files:
                  local bufnr = vim.fn.bufnr('/full/path/to/your/file.txt');
                  if bufnr ~= -1 then
                    local diagnostics = {{bufnr=bufnr, lnum=324, col=0, message='This is the ErrorMessage', severity=vim.diagnostic.severity.ERROR}};
                    vim.diagnostic.set(ns, bufnr, diagnostics);
                    vim.fn.setqflist(vim.diagnostic.toqflist(diagnostics), 'a');
                  end
                end
                ]]
              return content .. "\nExample:\n" .. example:gsub("\n", " "):gsub(" +", " ")
            end,
          },
        },
      },
      ["agent"] = {
        strategy = "inline",
        description = "Ask agent",
        opts = {
          index = 24,
          is_default = false,
          short_name = "agent",
          is_slash_cmd = false,
          auto_submit = true,
          user_prompt = true,
          adapter = {
            name = "copilot",
            model = "gpt-4.1",
          },
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function(context)
              buffer = "#{buffer}\n"
              tools = "@{cmd_runner} @{files} @{insert_edit_into_file}\n"
              return buffer
                .. tools
                .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
            end,
          },
        },
      },
    },
  })
end

function ConfigBuilder:add_workflow_prompt_library()
  return self:_merge({
    interactions = {
      chat = {
        tools = {
          ["create_file"] = {
            opts = {
              require_approval_before = false,
            },
          },
          ["delete_file"] = {
            opts = {
              require_approval_before = false,
            },
          },
          ["read_file"] = {
            opts = {
              require_approval_before = false,
            },
          },
          ["insert_edit_into_file"] = {
            opts = {
              require_approval_before = {
                buffer = false,
                file = false,
              },
              require_confirmation_after = false,
            },
          },
          ["run_command"] = {
            opts = {
              require_cmd_approval = false,
              require_approval_before = function(tool)
                local cmd = (((tool or {}).args or {}).cmd or ""):lower()
                return cmd:match("%f[%a]rm%f[%A]") ~= nil
              end,
            },
          },
          groups = {
            ["my_agent"] = {
              description = "My custom agent",
              system_prompt = function(group, ctx)
                return string.format("You are a coding agent. write llm.txt to repository root", ctx.date, ctx.os)
              end,
              tools = { "read_file", "insert_edit_into_file", "run_command" },
              opts = {
                collapse_tools = true,
                ignore_system_prompt = true, -- Remove the chat's default system prompt
                ignore_tool_system_prompt = true, -- Remove the default tool system prompt
              },
            },
            ["test"] = {
              description = "My custom agent",
              system_prompt = function(group, ctx)
                return string.format("just say hoo!")
              end,
              tools = { "read_file", "insert_edit_into_file", "run_command" },
              opts = {
                collapse_tools = false,
                ignore_system_prompt = true, -- Remove the chat's default system prompt
                ignore_tool_system_prompt = true, -- Remove the default tool system prompt
              },
            },
            ["sample_agent"] = {
              description = "Sample agent for learning group behavior",
              prompt = [[Agent mode is active with ${tools}.
Follow these strict rules for this turn:
1) First line of your final answer must be exactly `SAMPLE_AGENT_ACTIVE`
2) Call `read_file` before any `run_command`
3) If `read_file` fails, explain why in Japanese before any command]],
              system_prompt = function(group, ctx)
                return string.format(
                  [[You are a cautious coding agent.
Strict verification rules:
- The first line of every assistant response must be exactly: SAMPLE_AGENT_ACTIVE
- Before any run_command call, you must call read_file at least once in the same turn.
- If read_file cannot be used (target not found), explain why in Japanese before run_command.

Execution policy:
1) Use read_file first to inspect relevant files.
2) Explain a short plan in Japanese.
3) If edits are needed, use insert_edit_into_file.
4) If verification is needed, use run_command with the smallest safe command.
Current date: %s
Project root: %s]],
                  ctx.date,
                  ctx.cwd
                )
              end,
              tools = { "read_file", "insert_edit_into_file", "run_command" },
              opts = {
                collapse_tools = true,
                ignore_system_prompt = true,
                ignore_tool_system_prompt = true,
              },
            },
            ["auto_agent"] = {
              description = "Auto-approve agent (asks only for rm commands)",
              system_prompt = function(_, ctx)
                return string.format(
                  [[You are a high-autonomy coding agent.
Default behavior:
- Execute tools directly without asking for permission.
- For shell commands, only ask for confirmation when the command contains `rm`.
- Be concise and action-first.
Project root: %s]],
                  ctx.cwd
                )
              end,
              tools = {
                "create_file",
                "delete_file",
                "file_search",
                "get_changed_files",
                "get_diagnostics",
                "grep_search",
                "insert_edit_into_file",
                "read_file",
                "run_command",
                "web_search",
              },
              opts = {
                collapse_tools = true,
                ignore_system_prompt = true,
                ignore_tool_system_prompt = true,
              },
            },
          },
        },
      },
    },
    prompt_library = {
      ["Edit<->Test workflow"] = {
        strategy = "workflow",
        description = "Use a workflow to repeatedly edit then test code",
        opts = {
          index = 5,
          is_default = true,
          short_name = "et",
        },
        prompts = {
          {
            {
              name = "Setup Test",
              role = "user",
              opts = { auto_submit = false },
              content = function()
                -- Leverage YOLO mode which disables the requirement of approvals and automatically saves any edited buffer
                local approvals = require("codecompanion.interactions.chat.tools.approvals")
                approvals:toggle_yolo_mode()

                return [[### Instructions

Your instructions here

### Steps to Follow

You are required to write code following the instructions provided above and test the correctness by running the designated test suite. Follow these steps exactly:

1. Update the code in #{buffer} using the @{insert_edit_into_file} tool
2. Then use the @{run_command} tool to run the test suite with `<test_cmd>` (do this after you have updated the code)
3. Make sure you trigger both tools in the same response

We'll repeat this cycle until the tests pass. Ensure no deviations from these steps.]]
              end,
            },
          },
          {
            {
              name = "Repeat On Failure",
              role = "user",
              opts = { auto_submit = true },
              -- Scope this prompt to the run_command tool
              condition = function()
                return _G.codecompanion_current_tool == "run_command"
              end,
              -- Repeat until the tests pass, as indicated by the testing flag
              -- which the run_command tool sets on the chat buffer
              repeat_until = function(chat)
                return chat.tool_registry.flags.testing == true
              end,
              content = "The tests have failed. Can you edit the buffer and run the test suite again?",
            },
          },
        },
      },
      ["Watch tmux pane workflow"] = {
        strategy = "workflow",
        description = "Select a tmux pane and keep watching logs until the pane task completes",
        opts = {
          index = 6,
          is_default = false,
          short_name = "tmux_watch",
          alias = "tmux_watch",
        },
        prompts = {
          {
            {
              name = "Select Pane and Start",
              role = "user",
              opts = { auto_submit = true },
              content = function(context)
                local make_tmux_watch_prompt = require("plugins.codecompanion.utils.tmux-workflow").make_tmux_watch_prompt
                return make_tmux_watch_prompt(context)
              end,
            },
          },
          {
            {
              name = "Keep Watching",
              role = "user",
              opts = { auto_submit = true },
              condition = function(chat)
                return chat.tools and chat.tools.tool and chat.tools.tool.name == "run_command"
              end,
              repeat_until = function(chat)
                local last = chat.messages[#chat.messages]
                local content = last and last.content or ""
                return type(content) == "string" and content:match("TMUX_WATCH_DONE") ~= nil
              end,
              content = "Continue the same cycle. If failures remain and task implies fixing, apply one small fix before next monitor cycle.",
            },
          },
        },
      },
    },
  })
end

function ConfigBuilder:add_prompt_libraryv2()
  return self:_merge({
    prompt_library = {
      ["Generate a Commit Message for Staged Files"] = {
        strategy = "inline",
        description = "staged file commit messages",
        opts = {
          index = 15,
          is_default = false,
          is_slash_cmd = true,
          short_name = "scommit",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return "You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:"
                .. "\n\n```diff\n"
                .. vim.fn.system("git diff --staged")
                .. "\n```"
            end,
          },
        },
      },
      ["Add Documentation"] = {
        strategy = "inline",
        description = "Add documentation to the selected code",
        opts = {
          index = 16,
          is_default = false,
          modes = { "v" },
          short_name = "doc",
          is_slash_cmd = true,
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = "When asked to add documentation, follow these steps:\n"
              .. "1. **Identify Key Points**: Carefully read the provided code to understand its functionality.\n"
              .. "2. **Review the Documentation**: Ensure the documentation:\n"
              .. "  - Includes necessary explanations.\n"
              .. "  - Helps in understanding the code's functionality.\n"
              .. "  - Follows best practices for readability and maintainability.\n"
              .. "  - Is formatted correctly.\n\n"
              .. "For C/C++ code: use Doxygen comments using `\\` instead of `@`.\n"
              .. "For Python code: Use Docstring numpy-notypes format.",
            opts = {
              visible = false,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              return "Please document the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["Refactor"] = {
        strategy = "chat",
        description = "Refactor the selected code for readability, maintainability and performances",
        opts = {
          index = 17,
          is_default = false,
          modes = { "v" },
          short_name = "refactor",
          is_slash_cmd = true,
          auto_submit = true,
          user_prompt = false,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = "When asked to optimize code, follow these steps:\n"
              .. "1. **Analyze the Code**: Understand the functionality and identify potential bottlenecks.\n"
              .. "2. **Implement the Optimization**: Apply the optimizations including best practices to the code.\n"
              .. "3. **Shorten the code**: Remove unnecessary code and refactor the code to be more concise.\n"
              .. "3. **Review the Optimized Code**: Ensure the code is optimized for performance and readability. Ensure the code:\n"
              .. "  - Maintains the original functionality.\n"
              .. "  - Is more efficient in terms of time and space complexity.\n"
              .. "  - Follows best practices for readability and maintainability.\n"
              .. "  - Is formatted correctly.\n\n"
              .. "Use Markdown formatting and include the programming language name at the start of the code block.",
            opts = {
              visible = false,
            },
          },
          {
            role = "user",
            content = function(context)
              local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

              return "Please optimize the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ["PullRequest"] = {
        strategy = "chat",
        description = "Generate a Pull Request message description",
        opts = {
          index = 18,
          is_default = false,
          short_name = "pr",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              return "You are an expert at writing detailed and clear pull request descriptions."
                .. "Please create a pull request message following standard convention from the provided diff changes."
                .. "Ensure the title, description, type of change, checklist, related issues, and additional notes sections are well-structured and informative."
                .. "\n\n```diff\n"
                .. vim.fn.system("git diff $(git merge-base HEAD main)...HEAD")
                .. vim.fn.system("git diff $(git merge-base HEAD develop)...HEAD")
                .. "\n```"
            end,
          },
        },
      },
      ["Bug Finder"] = {
        strategy = "chat",
        description = "Find potential bugs from the provided diff changes",
        opts = {
          index = 20,
          is_default = false,
          short_name = "bugs",
          is_slash_cmd = true,
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local question = "<question>\n"
                .. "Check if there is any bugs that have been introduced from the provided diff changes.\n"
                .. "Perform a complete analysis and do not stop at first issue found.\n"
                .. "If available, provide absolute file path and line number for code snippets.\n"
                .. "</question>"

              local branch = "$(git merge-base HEAD origin/develop)...HEAD"
              local changes = "changes.diff"
              vim.fn.system("git diff --unified=10000 " .. branch .. " > " .. changes)

              --- @type CodeCompanion.Chat
              local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
              local path = vim.fn.getcwd() .. "/" .. changes
              local id = "<file>" .. changes .. "</file>"
              local lines = vim.fn.readfile(path)
              local content = table.concat(lines, "\n")

              chat:add_message({
                role = "user",
                content = "git diff content from " .. path .. ":\n" .. content,
              }, { reference = id, visible = false })

              chat.context:add({
                id = id,
                path = path,
                source = "",
              })

              return question
            end,
          },
        },
      },
      ["Split Commits"] = {
        strategy = "chat",
        description = "agent mode with explicit set of tools",
        opts = {
          index = 21,
          is_default = false,
          short_name = "commits",
          is_slash_cmd = true,
          auto_submit = false,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
              local logs = vim.fn.system('git log --pretty=format:"%s%n%b" -n 50')
              local commit_history = "Commit history for branch " .. current_branch .. ":\n" .. logs .. "\n\n"
              local staged_changes = "Staged files:\n" .. vim.fn.system("git diff --cached --name-only")
              local prompt = "<prompt>" .. commit_history .. staged_changes .. "</prompt> \n\n"
              local task = "You are an expert Git assistant.\n"
                .. "Your task is to help the user create well-structured and conventional commits from their currently staged changes.\n\n"
                .. "Based on the provided commit logs and branch name, first, infer the established commit message convention\n"
                .. "Next, use the staged changes to determine the logical grouping of changes and generate appropriate commit messages.\n\n"
                .. "Your primary goal is to analyze these staged changes and determine if they should be split into multiple logical and separate commits.\n"
                .. "If the staged changes are empty or too trivial for a meaningful commit, please state that.\n\n"
                .. "Use @{cmd_runner} to execute git commands for staging and un-staging files to group staged changes into meaningful commits when necessary."
              return prompt .. task
            end,
          },
        },
      },
      ["agent"] = {
        strategy = "inline",
        description = "Ask agent",
        opts = {
          index = 24,
          is_default = false,
          short_name = "agent",
          is_slash_cmd = false,
          auto_submit = true,
          user_prompt = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function(context)
              buffer = "#{buffer}\n"
              tools = "@{cmd_runner} @{files} @{insert_edit_into_file}\n"
              return buffer
                .. tools
                .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
            end,
          },
        },
      },
    },
  })
end

function ConfigBuilder:change_chat_role_display()
  return self:_merge({
    interactions = {
      chat = {
        roles = {
          user = "",
          llm = function(adapter)
            return "  " .. adapter.formatted_name
          end,
        },
      },
    },
  })
end

---@param adapter AdapterNameAndModel
function ConfigBuilder:specific_chat_adapter(adapter)
  return self:_merge({
    interactions = {
      chat = {
        adapter = adapter,
      },
    },
  })
end

function ConfigBuilder:extend_chat_tools()
  return self:_merge({
    strategy = {
      chat = {
        tools = {
          opts = {
            auto_submit_errors = true, -- Send any errors to the LLM automatically?
            auto_submit_success = true, -- Send any successful output to the LLM automatically?
          },
          ["mcp"] = {
            -- calling it in a function would prevent mcphub from being loaded before it's needed
            callback = function()
              return require("mcphub.extensions.codecompanion")
            end,
            description = "Call tools and resources from the MCP Servers",
          },
          ["cmd_runner"] = {
            opts = {
              requires_approval = false,
            },
          },
        },
      },
    },
  })
end

function ConfigBuilder:integrate_minidiff()
  -- https://codecompanion.olimorris.dev/usage/inline-assistant
  return self:_merge({
    display = {
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = "horizontal", -- vertical|horizontal split for default provider
        opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
        provider = "mini_diff", -- default|mini_diff
      },
    },
  })
end

function ConfigBuilder:add_chat_slash_commands()
  return self:_merge({
    interactions = {
      chat = {
        slash_commands = {
          ["buffer"] = {
            opts = {
              provider = "snacks",
            },
          },
          ["file"] = {
            opts = {
              provider = "snacks",
            },
          },
          ["terminal"] = {
            ---@param chat CodeCompanion.Chat
            callback = function(chat)
              Snacks.picker.buffers({
                title = "Terminals",
                hidden = true,
                actions = {
                  ---@param picker snacks.Picker
                  add_to_chat = function(picker)
                    picker:close()
                    local items = picker:selected({ fallback = true })
                    vim.iter(items):each(function(item)
                      local id = "<buf>" .. chat.context:make_id_from_buf(item.buf) .. "</buf>"
                      local lines = vim.api.nvim_buf_get_lines(item.buf, 0, -1, false)
                      local content = table.concat(lines, "\n")

                      chat:add_message({
                        role = "user",
                        content = "Terminal content from buffer " .. item.buf .. " (" .. item.file .. "):\n" .. content,
                      }, { reference = id, visible = false })

                      chat.context:add({
                        bufnr = item.buf,
                        id = id,
                        source = "",
                      })
                    end)
                  end,
                },
                win = { input = { keys = { ["<CR>"] = { "add_to_chat", mode = { "i", "n" } } } } },
                filter = {
                  filter = function(item)
                    return vim.bo[item.buf].buftype == "terminal"
                  end,
                },
                main = { file = false },
              })
            end,
            description = "Insert terminal output",
            opts = {
              provider = "snacks",
            },
          },
        },
      },
    },
  })
end

-- function ConfigBuilder:specific_chat_display()
--   --TODO: これ必要なんか？
--   return self:_merge({
--     display = {
--       diff = { enabled = false },
--       chat = {
--         show_header_separator = false,
--         show_settings = false, -- do not show settings to allow model change with shortcut
--       },
--       action_palette = { provider = "default" },
--     },
--   })
-- end

function ConfigBuilder:add_openrouter_adapter()
  return self:_merge({
    adapters = {
      openrouter = function()
        return require("codecompanion.adapters").extend("openai", {
          name = "OpenRouter",
          url = "https://openrouter.ai/api/v1/chat/completions",
          env = {
            api_key = os.getenv("OPENROUTER_API_KEY"),
          },
          schema = {
            model = {
              default = "gpt-4",
            },
          },
        })
      end,
    },
  })
end

function ConfigBuilder:add_codex_oauth_adapter()
  local codex_oauth = require("opencode_openai_codex_auth.integrate.codecompanion")
  local adapter = codex_oauth.adapter_config()

  return self:_merge({
    adapters = {
      http = {
        codex_oauth = function()
          return require("codecompanion.adapters").extend("openai_responses", adapter)
        end,
      },
    },
  })
end

function ConfigBuilder:add_codex_acp_adapter()
  return self:_merge({
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            defaults = {
              auth_method = "chatgpt", -- "openai-api-key"|"codex-api-key"|"chatgpt"
            },
          })
        end,
      },
    },
  })
end

---@param adapter AdapterNameAndModel
function ConfigBuilder:set_title_generator_adapter(adapter)
  -- local adapter_name = type(adapter) == "table" and adapter.name or adapter
  -- local adapter_model = type(adapter) == "table" and adapter.model or nil

  -- NOTE:
  -- codecompanion-history title generation currently breaks for some custom
  -- HTTP adapters when `title_generation_opts.model` is set.
  -- For codex_oauth we force adapter only, and leave model unset.
  -- if adapter_name == "codex_oauth" then
  --   adapter_model = nil
  -- end

  self:_merge({
    extensions = {
      history = {
        opts = {
          title_generation_opts = {
            adapter = adapter.name,
            model = adapter.model,
          },
        },
      },
    },
  })

  return self
end

function ConfigBuilder:chat_edit_plugin()
  require("plugins.codecompanion.utils.chat-edit").setup({})
  return self
end

function ConfigBuilder:build()
  return self.opts
end

---@param adapter AdapterNameAndModel
function M.get_opts(adapter)
  local builder = ConfigBuilder.new()

  -- https://github.com/zed-industries/codex-acp
  if vim.fn.executable("codex-acp") == 1 then
    builder:add_codex_acp_adapter()
  elseif adapter == "codex" then
    error("codex-acp is not installed")
  end

  if adapter.name == "codex_oauth" then
    builder:add_codex_oauth_adapter()
  end

  builder
    :specific_chat_adapter(adapter)
    :set_inline_adapter(adapter)
    :set_title_generator_adapter(adapter)
    :change_chat_role_display()
    -- :add_prompt_libraryv2()
    -- :chat_edit_plugin()
    -- :extend_chat_tools()
    :setup_general_option()
    -- :add_prompt_library()
    :set_inline_keybind()
    :extend_mcphub()
    :extend_history()
    :integrate_minidiff()
    :add_workflow_prompt_library()
  -- :add_chat_slash_commands()
  -- :add_openrouter_adapter()

  if vim.fn.exists(":CodeCompanionTmuxWorkflow") == 0 then
    vim.api.nvim_create_user_command("CodeCompanionTmuxWorkflow", function(opts)
      local tmux = require("plugins.codecompanion.utils.tmux-workflow")
      local task = opts.args
      tmux.start_tmux_workflow(task)
    end, {
      nargs = "*",
      desc = "Select tmux pane (Telescope) and start tmux_watch workflow",
    })
  end

  return builder:build()
end

return M
