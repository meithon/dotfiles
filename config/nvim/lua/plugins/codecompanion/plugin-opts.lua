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

-- private methods

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

function ConfigBuilder:set_general()
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
        local language = opts.language or "English"
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

function ConfigBuilder:change_display()
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

function ConfigBuilder:build()
  return self.opts
end

function M.get_opts()
  local builder = ConfigBuilder.new()

  builder
    :specific_chat_adapter({
      name = "anthropic",
      model = "claude-haiku-4-5",
    })
    :set_inline_adapter({
      name = "anthropic",
      model = "claude-haiku-4-5",
    })
    :change_chat_role_display()
    :extend_chat_tools()
    :set_general()
    :add_prompt_library()
    :set_inline_keybind()
    :extend_mcphub()
    :extend_history()
    :change_display()
    :add_chat_slash_commands()
    :add_openrouter_adapter()

  return builder:build()
end

return M
