local Util = require("lazyvim.util")
local icons = require("lazyvim.config").icons
local events = require("neo-tree.events")
local filesystem = require("neo-tree.sources.filesystem")

local Path = require("plenary.path")

local function find_node_modules(start_path)
  local current_path = Path:new(start_path or vim.loop.cwd()):absolute()
  local root_path = Path:new("/"):absolute()

  while current_path ~= root_path do
    local node_modules_path = Path:new(current_path, "node_modules")

    if node_modules_path:exists() and node_modules_path:is_dir() then
      return node_modules_path:absolute()
    end

    -- Move up one directory
    current_path = Path:new(current_path):parent():absolute()
  end

  return "" -- node_modules not found
end
local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "Constant",
  }, opts or {})

  local path = vim.fn.expand("%:p") --[[@as string]]
  local root = Util.root.get({ normalize = true })
  local cwd = Util.root.cwd()
  local sep = package.config:sub(1, 1)

  return function()
    if path == "" then
      return ""
    end

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local parts = vim.split(path, "[\\/]")
    -- if #parts > 4 then
    --   parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    -- end

    -- if opts.modified_hl and vim.bo.modified then
    --   parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
    -- end

    return table.concat(parts, sep)
  end
end

---@alias KeyMode "n"|"i"|"v"|"x"|"s"|"o"|"t"|"c"|"l"|"r"|"!"|"v"

-- @alias Keymap fun(a: {[1]: string, [2]:string, mode:KeyMode[]|KeyMode, desc: string})

---@alias Filetype "qf" | "javascript" |"javascriptreact"|"typescriptreact" | "typescript"
---@alias VimEvent "BufAdd"| "BufDelete"| "BufEnter"| "BufFilePost"| "BufFilePre"| "BufHidden"| "BufLeave"| "BufModifiedSeufNewFile"| "BufRead" |  "BufReadPost"| "BufReadCmd"| "BufReadPre"| "BufUnload"| "BufWinEnter"| "BufWinLeave"| "BufWipeout"| "BufWrite" | "BufWritePre"| "BufWriteCmd"| "BufWritePost"| "ChanInfo"| "ChanOpen"| "CmdUndefined"| "CmdlineChanged"| "CmdlineEnter"| "CmdlineLeave"| "CmdwinEnter"| "CmdwinLeave"| "ColorScheme"| "ColorSchemePre"| "CompleteChanged"| "CompleteDonePre"| "CompleteDone"| "CursorHold"| "CursorHoldI" | "CursorMoved" | "CursorMovedI" | "DiffUpdated" | "DirChanged" | "DirChangedPre" | "ExitPre" | "FileAppendCmd" | "FileAppendPost" | "FileAppendPre" | "FileChangedRO" | "FileChangedShell" | "FileChangedShellPost" | "FileReadCmd" | "FileReadPost" | "FileReadPre" | "FileType" | "FileWriteCmd" | "FileWritePost" | "FileWritePre" | "FilterReadPost" | "FilterReadPre" | "FilterWritePost" | "FilterWritePre" | "FocusGained" | "FocusLost" | "FuncUndefined" | "UIEnter" | "UILeave" | "InsertChange" | "InsertCharPre" | "InsertEnter" | "InsertLeavePre" | "InsertLeave" | "MenuPopup" | "ModeChanged" |  "ModeChanged"  | "ModeChanged" |  "WinEnter"|"Win" | "OptionSet" | "QuickFixCmdPre" | "QuickFixCmdPost" | "QuitPre" | "RemoteReply" | "SearchWrapped" | "RecordingEnter" | "RecordingLeave" | "SessionLoadPost" | "ShellCmdPost" | "Signal" | "ShellFilterPost" | "SourcePre" | "SourcePost" | "SourceCmd" | "SpellFileMissing" | "StdinReadPost" | "StdinReadPre" | "SwapExists" | "Syntax" | "TabEnter" | "TabLeave" | "TabNew" | "TabNewEntered" | "TabClosed" | "TermOpen" | "TermEnter" | "TermLeave" | "TermClose" | "TermResponse" | "TextChanged" | "TextChangedI" | "TextChangedP" | "TextChangedT" | "TextYankPost" | "User" | "UserGettingBored" | "VimEnter" | "VimLeave" | "VimLeavePre" | "VimResized" | "VimResume" | "VimSuspend" | "WinClosed" | "WinEnter" | "WinLeave" | "WinNew" | "WinScrolled" | "WinResized"
---@alias PluginEvent VimEvent|"VaryLazy"

---@class Key
---@field [1] string
---@field [2] string|function | false
---@field mode? KeyMode[]|KeyMode
---@field desc? string

---@class OnePlugin
---@field [1] string
---@field opts? function | table
---@field keys? Key[]|Key|fun(): Key[]|Key
---@field event? PluginEvent[]|PluginEvent
---@field config? function | true
---@field ft? Filetype[]|Filetype
---@field enabled? false

---@class Plugin : OnePlugin
---@field dependencies? OnePlugin[]|OnePlugin |string[]|string

---@alias plugins.Plugin Plugin

---@type Plugin[]
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      scroll = { enabled = false },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          -- accept_word = "<Right>",
        },
        color = {
          suggestion_color = "#c8ffff",
          cterm = 244,
        },
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
                                                                        
                                                                        
                                                                        
                                                                        
                                                                      
       ████ ██████           █████      ██                      
      ███████████             █████                              
      █████████ ███████████████████ ███   ███████████    
     █████████  ███    █████████████ █████ ██████████████    
    █████████ ██████████ █████████ █████ █████ ████ █████    
  ███████████ ███    ███ █████████ █████ █████ ████ █████   
 ██████  █████████████████████ ████ █████ █████ ████ ██████  
                                                                        
                                                                        
                                                                        
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local slow_format_filetypes = {}
      -- async format
      -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#automatically-run-slow-formatters-async
      vim.tbl_deep_extend("force", opts, {
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_format = "fallback" }, on_format
        end,

        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_format = "fallback" }
        end,
      })
    end,
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = {
  --         enabled = true,
  --         auto_trigger = true,
  --         hide_during_completion = true,
  --         debounce = 75,
  --         keymap = {
  --           accept = "<right>",
  --           accept_word = false,
  --           accept_line = false,
  --           next = "<A-]>",
  --           prev = "<A-[>",
  --           dismiss = "<C-]>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "L3MON4D3/LuaSnip",

    dependencies = {
      -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
      {
        "numToStr/Comment.nvim",
        opts = {
          -- add any options here
        },
      },
    },
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- keys = {
    --   -- TODO: configure keymap in nvim-cmp
    --   {
    --     "<tab>",
    --     function()
    --       return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    --     end,
    --     expr = true,
    --     silent = true,
    --     mode = "i",
    --   },
    --   {
    --     "<tab>",
    --     function()
    --       require("luasnip").jump(1)
    --     end,
    --     mode = "s",
    --   },
    --   {
    --     "<s-tab>",
    --     function()
    --       require("luasnip").jump(-1)
    --     end,
    --     mode = { "i", "s" },
    --   },
    -- },
    -- dependencies = {
    --   { "saadparwaiz1/cmp_luasnip" },
    --   require("snippet").dependencies,
    -- },
    config = function()
      local ls = require("luasnip")

      --  NOTE: refs: https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs
      local select_next = false
      vim.keymap.set({ "i" }, "<C-l>", function()
        -- the meat of this mapping: call ls.activate_node.
        -- strict makes it so there is no fallback to activating any node in the
        -- snippet, and select controls whether the text associated with the node is
        -- selected.
        local ok, _ = pcall(ls.activate_node, {
          strict = true,
          -- select_next is initially unset, but set within the first second after
          -- activating the mapping, so activating it again in that timeframe will
          -- select the text of the found node.
          select = select_next,
        })
        -- ls.activate_node throws on failure.
        if not ok then
          print("No node.")
          return
        end

        -- once the node is activated, we are either done (if text is SELECTed), or
        -- we briefly highlight the text associated with the node so one can know
        -- which node was activated.
        -- TODO: this highlighting does not show up if the node has no text
        -- associated (ie ${1:asdf} vs $1), a cool extension would be to also show
        -- something if there was no text.
        if select_next then
          return
        end

        local curbuf = vim.api.nvim_get_current_buf()
        local hl_duration_ms = 100

        local node = ls.session.current_nodes[curbuf]
        -- get node-position, raw means we want byte-columns, since those are what
        -- nvim_buf_set_extmark expects.
        local from, to = node:get_buf_position({ raw = true })

        -- highlight snippet for 1000ms
        local id = vim.api.nvim_buf_set_extmark(curbuf, ls.session.ns_id, from[1], from[2], {
          -- one line below, at col 0 => entire last line is highlighted.
          end_row = to[1],
          end_col = to[2],
          hl_group = "Visual",
        })
        -- disable highlight by removing the extmark after a short wait.
        vim.defer_fn(function()
          vim.api.nvim_buf_del_extmark(curbuf, ls.session.ns_id, id)
        end, hl_duration_ms)

        -- set select_next for the next second.
        select_next = true
        vim.uv.new_timer():start(1000, 0, function()
          select_next = false
        end)
      end)

      -- feel free to change the keys to new ones, those are just my current mappings
      vim.keymap.set("i", "<C-f>", function()
        if ls.choice_active() then
          return ls.change_choice(1)
        else
          return _G.dynamic_node_external_update(1) -- feel free to update to any index i
        end
      end, { noremap = true })
      vim.keymap.set("s", "<C-f>", function()
        if ls.choice_active() then
          return ls.change_choice(1)
        else
          return _G.dynamic_node_external_update(1)
        end
      end, { noremap = true })
      vim.keymap.set("i", "<C-d>", function()
        if ls.choice_active() then
          return ls.change_choice(-1)
        else
          return _G.dynamic_node_external_update(2)
        end
      end, { noremap = true })
      vim.keymap.set("s", "<C-d>", function()
        if ls.choice_active() then
          return ls.change_choice(-1)
        else
          return _G.dynamic_node_external_update(2)
        end
      end, { noremap = true })
      require("snippet").setup()
      -- \udb83\udfd8
      -- \udb83\udfd8
      -- \udb83\udfd8
      -- fuck
      -- 󰿘
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "typos-lsp")
    end,
  },
  {
    "folke/noice.nvim",
    lazy = false,
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        routes = {
          {
            view = "notify",
            filter = { event = "msg_showmode" },
          },
        },
        cmdline = {
          view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
          format = {
            cmdline = { pattern = "^:", icon = "|>", lang = "vim", title = "" },
          },
        },
        views = {
          cmdline_popup = {
            size = {
              height = "auto",
              width = "90%",
            },
            position = {
              row = "90%",
              col = "50%",
            },
            border = {
              style = "single",
            },
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["typescript"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["vue"] = { "biome" },
        ["css"] = { "biome" },
        ["scss"] = { "biome" },
        ["json"] = { "biome" },
        ["jsonc"] = { "biome" },
        ["handlebars"] = { "biome" },
      },
    },
  },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   vscode = true,
  --   ---@type Flash.Config
  --   opts = {},
  --   config = function()
  --     local enterMode = function(callback)
  --       callback()
  --       local s
  --       while true do
  --         s = vim.fn.getchar()
  --         if type(s) == "number" then
  --           local char = vim.fn.nr2char(s)
  --           local keys = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  --           if string.match(keys, char) then
  --             vim.defer_fn(function()
  --               vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(char, true, false, true), "n", false)
  --             end, 0)
  --             require("flash").jump()
  --             return
  --           else
  --             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(char, true, false, true), "n", false)
  --             return
  --           end
  --         else
  --           return
  --         end
  --       end
  --     end
  --
  --     local scroll_half_page_down = function()
  --       local win_height = vim.api.nvim_win_get_height(0)
  --       local cursor_height = vim.api.nvim_win_get_cursor(0)[1]
  --       local middle = math.floor(win_height / 2)
  --       local scroll_amount = 0
  --       if cursor_height < middle then
  --         scroll_amount = 2 * middle - cursor_height
  --       else
  --         scroll_amount = cursor_height - middle
  --       end
  --       vim.cmd("normal " .. scroll_amount .. "j zz")
  --     end
  --
  --     local scroll_half_page_up = function()
  --       local win_height = vim.api.nvim_win_get_height(0)
  --       local middle = math.floor(win_height / 2)
  --       local cursor_height = vim.api.nvim_win_get_cursor(0)[1]
  --       local scroll_amount = 0
  --       if cursor_height < middle then
  --         scroll_amount = 2 * middle - cursor_height
  --       else
  --         scroll_amount = cursor_height - middle
  --       end
  --       vim.cmd("normal " .. scroll_amount .. "k zz")
  --     end
  --
  --     vim.keymap.set("n", "<C-u>", function()
  --       enterMode(scroll_half_page_up)
  --     end, { noremap = true, silent = true })
  --
  --     vim.keymap.set("n", "<C-d>", function()
  --       enterMode(scroll_half_page_down)
  --     end, { noremap = true, silent = true })
  --   end,
  --
  --   -- stylua: ignore
  --   -- keys = {
  --   --   { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --   --   { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --   --   { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --   --   { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --   --   { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   -- },
  -- },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = function(_, opts)
  --     opts.sections.lualine_c = {
  --       {
  --         "diagnostics",
  --         symbols = {
  --           error = icons.diagnostics.Error,
  --           warn = icons.diagnostics.Warn,
  --           info = icons.diagnostics.Info,
  --           hint = icons.diagnostics.Hint,
  --         },
  --       },
  --       { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  --       {
  --         function()
  --           return Util.root.cwd()
  --         end,
  --       },
  --     }
  --     opts.inactive_winbar = {
  --       lualine_c = {
  --         pretty_path({ relative = "cwd" }),
  --       },
  --     }
  --     opts.winbar = {
  --
  --       lualine_c = {
  --         pretty_path({ relative = "cwd" }),
  --       },
  --     }
  --   end,
  -- },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      function codeCompanion()
        local M = require("lualine.component"):extend()

        M.processing = false
        M.spinner_index = 1

        local spinner_symbols = {
          "⠋",
          "⠙",
          "⠹",
          "⠸",
          "⠼",
          "⠴",
          "⠦",
          "⠧",
          "⠇",
          "⠏",
        }
        local spinner_symbols_len = 10

        -- Initializer
        function M:init(options)
          M.super.init(self, options)

          local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

          vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequest",
            group = group,
            callback = function(request)
              self.processing = (request.data.status == "started")
            end,
          })
        end

        -- Function that runs every time statusline is updated
        function M:update_status()
          if self.processing then
            self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
            return spinner_symbols[self.spinner_index]
          else
            return nil
          end
        end

        return M
      end
      opts.sections.lualine_c = {
        codeCompanion(),
      }
    end,
  },
  -- word highlight
  {
    "RRethy/vim-illuminate",
    config = function()
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
    end,
    opts = function(_, opts)
      opts.delay = 0
    end,
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },

    ---@param opts table
    opts = function(_, opts)
      opts = vim.tbl_extend("keep", opts, {
        ring = {
          history_length = 10,
        },
      })
    end,
    -- setup = function()
    --   require("yanky").setup({})
    -- end,
    --   highlight = { timer = 250 },
    --   ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    -- },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "David-Kunz/markid",
      "windwp/nvim-ts-autotag",
    },
    opts = function(_, opts)
      -- require("nvim-treesitter.parsers").filetype_to_parsername.zsh = "bash"
      vim.filetype.add({
        extension = {
          zsh = "bash",
        },
        pattern = {
          [".*%.zsh"] = "bash",
          ["%.zshrc"] = "bash",
          ["%.zshenv"] = "bash",
          ["%.zprofile"] = "bash",
          ["%.zlogin"] = "bash",
          ["%.zlogout"] = "bash",
        },
      })
      opts.markid = {
        enable = true,
      }
      opts.autotag = {
        enable = true,
      }
    end,
  },
  { -- Add vitest runner
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      -- "rneithon/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      table.insert(opts.adapters, require("neotest-vitest"))
      table.insert(
        opts.adapters,
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = false,

            enable_dynamic_test_discovery = true,

            preset = "debug", -- "none" | "headed" | "debug"

            get_playwright_binary = function()
              --   return vim.loop.cwd() + "/node_modules/.bin/playwright"
              return find_node_modules() .. "/.bin/playwright"
            end,

            get_playwright_config = function()
              -- return vim.loop.cwd() + "/packages/e2e-test/playwright.config.ts"
              return "/Users/mei/workspace/work/tobari/packages/e2e-test/playwright.config.ts"
            end,

            -- Controls the location of the spawned test process.
            -- Has no affect on neither the location of the binary nor the location of the config file.
            -- get_cwd = function()
            --   return vim.loop.cwd()
            -- end,

            -- env = { },

            -- Extra args to always passed to playwright. These are merged with any extra_args passed to neotest's run command.
            extra_args = {
              "--trace=retain-on-failure",
            },

            -- Filter directories when searching for test files. Useful in large projects (see performance notes).
            -- filter_dir = function(name, rel_path, root)
            --   return name ~= "node_modules"
            -- end,

            ---Filter directories when searching for test files
            -- @ async
            -- @ param name string Name of directory
            -- @ param rel_path string Path to directory, relative to root
            -- @ param root string Root directory of project
            -- @ return boolean
            -- filter_dir = function(name, rel_path, root)
            --   local full_path = root .. "/" .. rel_path
            --
            --   if root:match("tobari") then
            --     if full_path:match("^packages/e2e-test") then
            --       return true
            --     else
            --       return false
            --     end
            --   else
            --     return name ~= "node_modules"
            --   end
            -- end,
          },
        })
      )
      table.insert(opts, {
        consumers = {
          playwright = require("neotest-playwright").consumers,
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local cc = require("neo-tree.sources.common.commands")
      local renderer = require("neo-tree.ui.renderer")
      local fs_scan = require("neo-tree.sources.filesystem.lib.fs_scan")
      local highlights = require("neo-tree.ui.highlights")
      local utils = require("neo-tree.utils")
      local NuiSplit = require("nui.split")
      local manager = require("neo-tree.sources.manager")

      local function remove_trailing_slash(path)
        if path:sub(-1) == "/" then
          return path:sub(1, -2)
        end
        return path
      end
      local function openNewPane(path)
        path = remove_trailing_slash(path)

        local state = manager.get_state(
          "filesystem",
          path, -- hack tab id table for run create_state
          nil
        )
        state.tabid = vim.api.nvim_get_current_tabpage()
        state.follow_current_file.enabled = false
        state.path = path

        state.current_position = "current"
        state.dirty = true

        local win_options = {
          ns_id = highlights.ns_id,
          size = utils.resolve_config_option(state, "window.width", "40"),
          position = "left",
          relative = "editor",
          buf_options = {
            buftype = "nofile",
            modifiable = false,
            swapfile = false,
            filetype = "neo-tree",
            undolevels = -1,
          },
          win_options = {
            colorcolumn = "",
            signcolumn = "no",
          },
        }

        local win = NuiSplit(win_options)
        local ok = pcall(win.mount, win)
        if not ok then
          return
        end

        state.bufnr = win.bufnr
        state.winid = 0 -- for hack window_exists
        state.id = win.winid
        state.async_directory_scan = "always"
        state.commands = vim.tbl_extend("force", state.commands or {}, {
          close_window = function()
            pcall(vim.api.nvim_win_close, win.winid, true)
          end,
        })

        fs_scan.get_items(state, nil, state.path, function() end)
      end

      vim.api.nvim_create_user_command("NeotreeNewPane", function(args)
        openNewPane(args.args)
      end, {
        desc = "Open Neotree in a new pane",
        nargs = 1, -- Exactly one required argument
        complete = "dir", -- File path completion
      })

      -- NOTE: Manage clipboard in global state
      local function getAddress(t)
        return string.match(tostring(t), "0x%x+")
      end

      local global_state = {
        clipboard = {},
        states = {},
      }

      function global_state.manage(state)
        state.clipboard = global_state.clipboard

        local address = getAddress(state)
        global_state.states[address] = state

        return state
      end

      function global_state.redraw_callback()
        return function()
          for _, state in pairs(global_state.states) do
            renderer.redraw(state)
          end
        end
      end

      local copy_to_clipboard = function(state)
        local gs = global_state.manage(state)
        cc.copy_to_clipboard(gs, global_state.redraw_callback())
      end

      local copy_to_clipboard_visual = function(state, selected_nodes)
        local gs = global_state.manage(state)
        cc.copy_to_clipboard_visual(gs, selected_nodes, global_state.redraw_callback())
      end

      local cut_to_clipboard = function(state)
        local gs = global_state.manage(state)
        cc.cut_to_clipboard(gs, global_state.redraw_callback())
        -- injectGlobalClipboard(cc.cut_to_clipboard, state, utils.wrap(redraw, state))
      end

      local cut_to_clipboard_visual = function(state, selected_nodes)
        local gs = global_state.manage(state)
        cc.cut_to_clipboard_visual(gs, selected_nodes, global_state.redraw_callback())
      end

      local paste_from_clipboard = function(state)
        local gs = global_state.manage(state)
        cc.paste_from_clipboard(gs, global_state.redraw_callback())
      end

      -- FIXME: broken clipboard
      -- opts.commands = vim.tbl_extend("force", opts.commands or {}, {
      --   g_copy_to_clipboard = copy_to_clipboard,
      --   g_copy_to_clipboard_visual = copy_to_clipboard_visual,
      --   g_cut_to_clipboard = cut_to_clipboard,
      --   g_cut_to_clipboard_visual = cut_to_clipboard_visual,
      --   g_paste_from_clipboard = paste_from_clipboard,
      -- })

      opts.window.mappings = vim.tbl_extend("force", opts.window.mappings, {
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        -- ["H"] = "close_all_nodes",
        ["l"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if not node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            elseif node:has_children() then
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        end,
        -- FIXME: broken clipboard
        -- ["y"] = "g_copy_to_clipboard",
        -- ["x"] = "g_cut_to_clipboard",
        -- ["p"] = "g_paste_from_clipboard",
        -- run command
        ["i"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.api.nvim_input(": " .. path .. "<Home>")
        end,
        -- open terminal
        ["e"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          local dir = path
          if not vim.fn.isdirectory(path) then
            local dir = vim.fs.dirname(path)
          end
          vim.cmd('ToggleTerm dir="' .. dir .. '"')
        end,
        ["F"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          local dir = path
          if not vim.fn.isdirectory(path) then
            local dir = vim.fs.dirname(path)
          end
          require("telescope.builtin").find_files({ cwd = dir })
        end,

        -- ["h"] = function(state)
        --   local node = state.tree:get_node()
        --   if node.type == "directory" and node:is_expanded() then
        --     require("neo-tree.sources.filesystem").toggle_directory(state, node)
        --   else
        --     require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        --   end
        -- end,
      })
    end,
  },
  { -- add window picker to neo-tree
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          -- 1. Lua関数を定義
          local function greet(name)
            print("Hello, " .. name .. "!")
          end

          -- 2. Neovimコマンドを作成
          vim.api.nvim_create_user_command("Greet", function(opts)
            local name = opts.args
            greet(name)
          end, { nargs = 1 })

          local manager = require("neo-tree.sources.manager")
          vim.api.nvim_create_user_command("NewNvimtree", function(opts)
            local winid = vim.api.nvim_get_current_win()
            local state = manager.get_state("filesystem", nil, winid)
            manager.navigate(state, nil, nil, nil, false)
          end, {})

          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            highlights = {
              statusline = {
                focused = {
                  fg = "#ededed",
                  bg = "#e35e4f",
                  bold = true,
                },
                unfocused = {
                  fg = "#ededed",
                  bg = "#44cc41",
                  bold = true,
                },
              },
              winbar = {
                focused = {
                  fg = "#ededed",
                  bg = "#e35e4f",
                  bold = true,
                },
                unfocused = {
                  fg = "#ededed",
                  bg = "#44cc41",
                  bold = true,
                },
              },
            },
          })
        end,
      },
    },
  },

  -- { --
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local null_ls = require("null-ls")
  --     for i, item in ipairs(opts) do
  --       if item == null_ls.builtins.diagnostics.eslint then
  --         opts[i] = null_ls.builtins.diagnostics.eslint.with({
  --           diagnostics_postprocess = function(diagnostic)
  --             diagnostic.severity = vim.diagnostic.severity.WARN
  --           end,
  --         })
  --         break
  --       end
  --     end
  --     table.insert(
  --       opts.sources,
  --       null_ls.builtins.diagnostics.eslint.with({
  --         diagnostics_postprocess = function(diagnostic)
  --           diagnostic.severity = vim.diagnostic.severity.WARN
  --         end,
  --       })
  --     )
  --   end,
  --
  -- },
  { -- better typescript error
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
    -- opts = function(_, opts)
    --
    --   -- table.insert(opts.inlay_hints, { enabled = false })
    -- end,
  },
  { -- better typescript error
    "neovim/nvim-lspconfig",
    dependencies = "davidosomething/format-ts-errors.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    keys = {
      {
        "gd",
        [[<cmd>require("telescope.builtin").lsp_definitions({ reuse_win = false })<cr>]],
        mode = "n",
        desc = "Goto Definition",
      },
    },
    opts = function(_, opts)
      opts.servers.tsserver.handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          if result.diagnostics == nil then
            return
          end

          -- ignore some tsserver diagnostics
          local idx = 1
          while idx <= #result.diagnostics do
            local entry = result.diagnostics[idx]

            local formatter = require("format-ts-errors")[entry.code]
            entry.message = formatter and formatter(entry.message) or entry.message

            -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            if entry.code == 80001 then
              -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
              table.remove(result.diagnostics, idx)
            else
              idx = idx + 1
            end
          end

          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
      }
      -- table.insert(opts.servers.rust_analyzer.settings["rust-analyzer"].procMacro.ignored, {
      --   leptos_macro = {
      --     -- optional: --
      --     -- "component",
      --     "server",
      --   },
      -- })
      -- require('lspconfig').rust_analyzer.setup {
      --   -- Other Configs ...
      --   settings = {
      --     ["rust-analyzer"] = {
      --       -- Other Settings ...
      --       procMacro = {
      --         ignored = {
      --             leptos_macro = {
      --                 -- optional: --
      --                 -- "component",
      --                 "server",
      --             },
      --         },
      --       },
      --     },
      --   }
      -- }
    end,
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   dependencies = {
  --     "poljar/typos.nvim",
  --   },
  --   opts = function(_, opts)
  --     local typos = require("typos")
  --     typos.setup()
  --     table.insert(opts.sources, typos.actions)
  --   end,
  -- },

  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
        },
      })
    end,
  },
  { -- Treesitter text object
    "ziontee113/syntax-tree-surfer",
    vscode = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = function()
      local get_current_window_id = vim.api.nvim_get_current_win
      local get_current_cursor_pos = vim.api.nvim_win_get_cursor

      local current_buffer = 0

      ---@class RestorePosition
      ---@field window_id number
      ---@field buf number
      ---@field pos number[]
      ---@field ns_id integer
      ---@field extmark_id number
      local RestorePosition = {}
      function RestorePosition.new()
        local self = setmetatable({}, RestorePosition)
        self.window_id = get_current_window_id()
        self.buf = vim.api.nvim_get_current_buf()
        self.pos = get_current_cursor_pos(self.window_id)
        self.ns_id = vim.api.nvim_create_namespace("flash_text_object")
        self.extmark_id = vim.api.nvim_buf_set_extmark(self.buf, self.ns_id, self.pos[1], self.pos[2], {})
        self.restore = function()
          vim.api.nvim_set_current_win(self.window_id)
          local pos = vim.api.nvim_buf_get_extmark_by_id(self.buf, self.ns_id, self.extmark_id, {})
          vim.api.nvim_win_set_cursor(self.window_id, pos)
          vim.api.nvim_buf_del_extmark(self.buf, self.ns_id, self.extmark_id)
        end
        return self
      end
      -- function RestorePosition.restore(self)
      --   vim.api.nvim_set_current_win(self.window_id)
      --   vim.api.nvim_buf_get_extmark_by_id(self.buf, self.ns_id, self.extmark_id, {})
      --   vim.api.nvim_buf_del_extmark(self.buf, self.ns_id, self.extmark_id)
      -- end

      ---@param cmd string
      ---@param node_type "current"|"master"
      ---@return nil
      local function flash_text_object(cmd, node_type)
        -- local restore_position = RestorePosition.new()
        local saved_window_id = get_current_window_id()
        local saved_buf = vim.api.nvim_get_current_buf()
        local saved_pos = get_current_cursor_pos(saved_window_id)
        local ns_id = vim.api.nvim_create_namespace("flash_text_object")
        local saved_extmark_id = vim.api.nvim_buf_set_extmark(saved_buf, ns_id, saved_pos[1], saved_pos[2], {})

        require("flash").jump()
        -- if was not moved, not select current node
        if saved_window_id == get_current_window_id() and saved_pos == vim.api.nvim_win_get_cursor(saved_window_id) then
          vim.api.nvim_buf_del_extmark(saved_buf, ns_id, saved_extmark_id)
          return nil
        end

        if node_type == "currenta" then
          require("syntax-tree-surfer").select_current_node()
        else
          require("syntax-tree-surfer").select()
        end
        if cmd == "" then -- its means a in select mode
          local augroup = vim.api.nvim_create_augroup("DetectModeChange", { clear = true })

          vim.api.nvim_create_autocmd({ "ModeChanged" }, {
            group = augroup,
            pattern = "*:*",
            callback = function()
              if vim.api.nvim_get_mode().mode ~= "v" then
                vim.api.nvim_clear_autocmds({ group = augroup })

                -- restore_position.restore()
                vim.api.nvim_set_current_win(saved_window_id)
                local pos = vim.api.nvim_buf_get_extmark_by_id(saved_buf, ns_id, saved_extmark_id, {})
                vim.api.nvim_win_set_cursor(saved_window_id, pos)
                vim.api.nvim_buf_del_extmark(saved_buf, ns_id, saved_extmark_id)
              end
            end,
          })
        else
          vim.cmd("normal! " .. cmd)
          -- restore_position.restore()
          vim.api.nvim_set_current_win(saved_window_id)
          local pos = vim.api.nvim_buf_get_extmark_by_id(saved_buf, ns_id, saved_extmark_id, {})
          vim.api.nvim_win_set_cursor(saved_window_id, pos)
          vim.api.nvim_buf_del_extmark(saved_buf, ns_id, saved_extmark_id)
        end
      end

      --- Define keymap
      ---@param cmd string
      ---@param node_type "current"|"master
      ---@return function
      local function df(cmd, node_type)
        return function()
          flash_text_object(cmd, node_type)
        end
      end

      ---@type Key[]
      return {
        -- { "vs", df("", "master"), mode = "n", desc = "Flash then Select" },
        -- { "Vs", df("", "current"), mode = "n", desc = "Flash then Select" },
        -- { "Ds", df("d", "master"), mode = "n", desc = "Select Master Node then Delete" },
        -- { "ys", df("y", "master"), mode = "n", desc = "Select Master Node then Yank" },
        -- { "Xs", df("x", "current"), mode = "n", desc = "Select Node then Dlete (not yank)" },
        -- { "ds", df("d", "current"), mode = "n", desc = "Select Node then Delete" },
        -- { "Ys", df("y", "current"), mode = "n", desc = "Select Node then Yank" },
        { "vi", "<cmd>STSSelectCurrentNode<cr>", mode = "n", desc = "Select Current Node" },
        { "va", "<cmd>STSSelectMasterNode<cr>", mode = "n", desc = "Select Master Node" },
        { "N", "<cmd>STSSelectNextSiblingNode<cr>", mode = "x", desc = "Select Next Sibling Node" },
        { "P", "<cmd>STSSelectPrevSiblingNode<cr>", mode = "x", desc = "Select Previous Sibling Node" },
        { "K", "<cmd>STSSelectParentNode<cr>", mode = "x", desc = "Select Parent Node" },
        { "J", "<cmd>STSSelectChildNode<cr>", mode = "x", desc = "Select Child Node" },
      }
    end,
    opts = {},
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer(true)
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner(true, "V")
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },
  -- Disable indent line
  -- {
  --   "echasnovski/mini.indentscope",
  --   --   enabled = false,
  --   -- opts = function(_, opts)
  --   --   -- opts.draw.animation = require("mini.indentscope").gen_animation.none()
  --   --   -- table.insert(opts.draw.animation, require("mini.indentscope").gen_animation.none())
  --   --   -- vim.tbl_extend(
  --   --   --   "force",
  --   --   --   opts,
  --   --   --   { draw = {
  --   --   --     animation = require("mini.indentscope").gen_animation.none(),
  --   --   --   } }
  --   --   -- )
  --   -- end,
  -- },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      -- table.insert(opts.options, { show_close_icon = false })

      -- opts.options.show_close_icon = false
      opts.options = vim.tbl_extend("force", opts.options, {
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "underline",
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "jvgrootveld/telescope-zoxide",
    },
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Find Git File",
      },
      {
        "<leader><tab>",
        "<cmd>Telescope buffers<cr>",
        desc = "Buffers",
      },
      {
        "<leader>fz",
        "<cmd>Telescope zoxide list<<cr>",
        desc = "Buffers",
      },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").git_files(require("telescope.themes").get_dropdown({
            color_devicons = true,
            cwd = "~/.config/nvim",
            previewer = false,
            prompt_title = "Ecovim Dotfiles",
            sorting_strategy = "ascending",
            winblend = 4,
            layout_config = {
              horizontal = {
                mirror = false,
              },
              vertical = {
                mirror = false,
              },
              prompt_position = "top",
            },
          }))
        end,
        desc = "Find Dotfiles",
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gd",
        function()
          require("telescope.builtin").lsp_definitions({ reuse_win = false })
        end,
        mode = "n",
        desc = "Goto Definition",
      }
    end,
    -- change some options
    opts = function(_, opts)
      -- Useful for easily creating commands
      local z_utils = require("telescope._extensions.zoxide.utils")

      vim.tbl_deep_extend("keep", opts, {
        extensions = {
          zoxide = {
            prompt_title = "[ Walking on the shoulders of TJ ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print("Update to (" .. selection.z_score .. ") " .. selection.path)
                end,
              },
              ["<C-s>"] = {
                before_action = function(selection)
                  print("before C-s")
                end,
                action = function(selection)
                  vim.cmd.edit(selection.path)
                end,
              },
              -- Opens the selected entry in a new split
              ["<C-q>"] = { action = z_utils.create_basic_command("split") },
            },
          },
        },
      })

      require("telescope").load_extension("zoxide")

      -- layout_strategy = "horizontal",
      -- layout_config = { prompt_position = "top" },
      -- sorting_strategy = "ascending",
      -- winblend = 0,
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind-nvim",
      "L3MON4D3/LuaSnip",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          -- deprioritize_snippet,
          -- copilot_cmp_comparators.prioritize or function() end,
          cmp.config.compare.exact,
          cmp.config.compare.offset,
          cmp.config.compare.score,
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.sort_text,
          cmp.config.compare.order,
        },
      }

      opts.mapping = vim.tbl_deep_extend(
        "force",
        opts.mapping or {}, -- opts.mappingがnilの場合に備えて
        cmp.mapping.preset.insert({
          ["<C-y>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.mapping.close()
            else
              cmp.mapping.select_next_item()
            end
          end),
        })
      )
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping({
            c = function()
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            end,
          }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping({
            c = function()
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            end,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })

      --- Example integration with Tabnine and LuaSnip; falling back to inserting tab if neither has a completion
      -- vim.keymap.set("i", "<tab>", function()
      --   if require("tabnine.keymaps").has_suggestion() then
      --     return require("tabnine.keymaps").accept_suggestion()
      --   elseif require("luasnip").jumpable(1) then
      --     return require("luasnip").jump(1)
      --   else
      --     return "<tab>"
      --   end
      -- end, { expr = true })

      -- local lspkind = require("lspkind")
      -- local source_mapping = {
      --   npm = "   " .. "NPM",
      --   cmp_tabnine = "  ",
      --   Copilot = "",
      --   Codeium = "",
      --   nvim_lsp = "  " .. "LSP",
      --   buffer = "  " .. "BUF",
      --   nvim_lua = "  ",
      --   luasnip = "  " .. "SNP",
      --   calc = "  ",
      --   path = " 󰉖 ",
      --   treesitter = "  ",
      --   zsh = "  " .. "ZSH",
      -- }
      -- opts.formatting = {
      --   format = function(entry, vim_item)
      --     -- Set the highlight group for the Codeium source
      --     if entry.source.name == "codeium" then
      --       vim_item.kind_hl_group = "CmpItemKindCopilot"
      --     end
      --
      --     -- Get the item with kind from the lspkind plugin
      --     local item_with_kind = lspkind.cmp_format({
      --       mode = "symbol_text",
      --       maxwidth = 50,
      --       symbol_map = source_mapping,
      --     })(entry, vim_item)
      --     item_with_kind.kind = lspkind.symbolic(item_with_kind.kind, { with_text = true })
      --     item_with_kind.menu = source_mapping[entry.source.name]
      --     item_with_kind.menu = vim.trim(item_with_kind.menu or "")
      --     item_with_kind.abbr = string.sub(item_with_kind.abbr, 1, item_with_kind.maxwidth)
      --
      --     if entry.source.name == "cmp_tabnine" then
      --       if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
      --         item_with_kind.kind = " " .. lspkind.symbolic("Event", { with_text = false }) .. " TabNine"
      --         item_with_kind.menu = item_with_kind.menu .. entry.completion_item.data.detail
      --       else
      --         item_with_kind.kind = " " .. lspkind.symbolic("Event", { with_text = false }) .. " TabNine"
      --         item_with_kind.menu = item_with_kind.menu .. " TBN"
      --       end
      --     end
      --
      --     local function get_lsp_completion_context(completion, source)
      --       local ok, source_name = pcall(function()
      --         return source.source.client.config.name
      --       end)
      --       if not ok then
      --         return nil
      --       end
      --       if source_name == "tsserver" or source_name == "typescript-tools" then
      --         return completion.detail
      --       elseif source_name == "pyright" then
      --         if completion.labelDetails ~= nil then
      --           return completion.labelDetails.description
      --         end
      --       end
      --     end
      --     local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
      --     if completion_context ~= nil and completion_context ~= "" then
      --       item_with_kind.menu = item_with_kind.menu .. [[ -> ]] .. completion_context
      --     end
      --
      --     if string.find(vim_item.kind, "Color") then
      --       -- Override for plugin purposes
      --       vim_item.kind = "Color"
      --       local tailwind_item = require("cmp-tailwind-colors").format(entry, vim_item)
      --       item_with_kind.menu = lspkind.symbolic("Color", { with_text = false }) .. " Color"
      --       item_with_kind.kind = " " .. tailwind_item.kind
      --     end
      --
      --     return item_with_kind
      --   end,
      -- }
    end,
    -- config = function()
    --   local cmp = require("cmp")
    --   local copilot_cmp_comparators = require("copilot_cmp.comparators")
    --   local lspkind = require("lspkind")
    --   local luasnip = require("luasnip")
    --
    --   local source_mapping = {
    --     npm = "   " .. "NPM",
    --     cmp_tabnine = "  ",
    --     Copilot = "",
    --     Codeium = "",
    --     nvim_lsp = "  " .. "LSP",
    --     buffer = "  " .. "BUF",
    --     nvim_lua = "  ",
    --     luasnip = "  " .. "SNP",
    --     calc = "  ",
    --     path = " 󰉖 ",
    --     treesitter = "  ",
    --     zsh = "  " .. "ZSH",
    --   }
    --
    --
    --   cmp.setup({
    --     snippet = {
    --       expand = function(args)
    --         luasnip.lsp_expand(args.body)
    --       end,
    --     },
    --     mapping = cmp.mapping.preset.insert({
    --       ["<C-k>"] = cmp.mapping.select_prev_item(),
    --       ["<C-j>"] = cmp.mapping.select_next_item(),
    --       ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-2), { "i", "c" }),
    --       ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(2), { "i", "c" }),
    --       ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    --       ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    --       ["<C-e>"] = cmp.mapping({
    --         i = cmp.mapping.abort(),
    --         c = cmp.mapping.close(),
    --       }),
    --       ["<CR>"] = cmp.mapping.confirm({
    --         -- this is the important line for Copilot
    --         behavior = cmp.ConfirmBehavior.Replace,
    --         select = false,
    --       }),
    --       ["<Tab>"] = cmp.mapping(function(fallback)
    --         if cmp.visible() then
    --           cmp.select_next_item()
    --         elseif cmp.visible() and has_words_before() then
    --           cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --         elseif luasnip.expandable() then
    --           luasnip.expand()
    --         elseif luasnip.expand_or_jumpable() then
    --           luasnip.expand_or_jump()
    --         elseif check_backspace() then
    --           fallback()
    --         else
    --           fallback()
    --         end
    --       end, {
    --         "i",
    --         "s",
    --       }),
    --       ["<S-Tab>"] = cmp.mapping(function(fallback)
    --         if cmp.visible() then
    --           cmp.select_prev_item()
    --         elseif luasnip.jumpable(-1) then
    --           luasnip.jump(-1)
    --         else
    --           fallback()
    --         end
    --       end, {
    --         "i",
    --         "s",
    --       }),
    --       ["<C-l>"] = cmp.mapping(function(fallback)
    --         if luasnip.expandable() then
    --           luasnip.expand()
    --         elseif luasnip.expand_or_jumpable() then
    --           luasnip.expand_or_jump()
    --         else
    --           fallback()
    --         end
    --       end, {
    --         "i",
    --         "s",
    --       }),
    --       ["<C-h>"] = cmp.mapping(function(fallback)
    --         if luasnip.jumpable(-1) then
    --           luasnip.jump(-1)
    --         else
    --           fallback()
    --         end
    --       end, {
    --         "i",
    --         "s",
    --       }),
    --     }),
    --     formatting = {
    --       format = function(entry, vim_item)
    --         -- Set the highlight group for the Codeium source
    --         if entry.source.name == "codeium" then
    --           vim_item.kind_hl_group = "CmpItemKindCopilot"
    --         end
    --
    --         -- Get the item with kind from the lspkind plugin
    --         local item_with_kind = require("lspkind").cmp_format({
    --           mode = "symbol_text",
    --           maxwidth = 50,
    --           symbol_map = source_mapping,
    --         })(entry, vim_item)
    --         item_with_kind.kind = lspkind.symbolic(item_with_kind.kind, { with_text = true })
    --         item_with_kind.menu = source_mapping[entry.source.name]
    --         item_with_kind.menu = vim.trim(item_with_kind.menu or "")
    --         item_with_kind.abbr = string.sub(item_with_kind.abbr, 1, item_with_kind.maxwidth)
    --
    --         if entry.source.name == "cmp_tabnine" then
    --           if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
    --             item_with_kind.kind = " " .. lspkind.symbolic("Event", { with_text = false }) .. " TabNine"
    --             item_with_kind.menu = item_with_kind.menu .. entry.completion_item.data.detail
    --           else
    --             item_with_kind.kind = " " .. lspkind.symbolic("Event", { with_text = false }) .. " TabNine"
    --             item_with_kind.menu = item_with_kind.menu .. " TBN"
    --           end
    --         end
    --
    --         local function get_lsp_completion_context(completion, source)
    --           local ok, source_name = pcall(function()
    --             return source.source.client.config.name
    --           end)
    --           if not ok then
    --             return nil
    --           end
    --           if source_name == "tsserver" or source_name == "typescript-tools" then
    --             return completion.detail
    --           elseif source_name == "pyright" then
    --             if completion.labelDetails ~= nil then
    --               return completion.labelDetails.description
    --             end
    --           end
    --         end
    --         local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
    --         if completion_context ~= nil and completion_context ~= "" then
    --           item_with_kind.menu = item_with_kind.menu .. [[ -> ]] .. completion_context
    --         end
    --
    --         if string.find(vim_item.kind, "Color") then
    --           -- Override for plugin purposes
    --           vim_item.kind = "Color"
    --           local tailwind_item = require("cmp-tailwind-colors").format(entry, vim_item)
    --           item_with_kind.menu = lspkind.symbolic("Color", { with_text = false }) .. " Color"
    --           item_with_kind.kind = " " .. tailwind_item.kind
    --         end
    --
    --         return item_with_kind
    --       end,
    --     },
    --     -- You should specify your *installed* sources.
    --     sources = {
    --       {
    --         name = "copilot",
    --         priority = 11,
    --         max_item_count = 3,
    --       },
    --       {
    --         name = "nvim_lsp",
    --         priority = 10,
    --         -- Limits LSP results to specific types based on line context (Fields, Methods, Variables)
    --         entry_filter = limit_lsp_types,
    --       },
    --       { name = "npm", priority = 9 },
    --       { name = "codeium", priority = 9 },
    --       { name = "git", priority = 7 },
    --       { name = "cmp_tabnine", priority = 7 },
    --       {
    --         name = "luasnip",
    --         priority = 7,
    --         max_item_count = 5,
    --       },
    --       {
    --         name = "buffer",
    --         priority = 7,
    --         keyword_length = 5,
    --         max_item_count = 10,
    --         option = buffer_option,
    --       },
    --       { name = "nvim_lua", priority = 5 },
    --       { name = "path", priority = 4 },
    --       { name = "calc", priority = 3 },
    --     },
    --     sorting = {
    --       priority_weight = 2,
    --       comparators = {
    --         deprioritize_snippet,
    --         copilot_cmp_comparators.prioritize or function() end,
    --         cmp.config.compare.exact,
    --         cmp.config.compare.locality,
    --         cmp.config.compare.score,
    --         cmp.config.compare.recently_used,
    --         cmp.config.compare.offset,
    --         cmp.config.compare.sort_text,
    --         cmp.config.compare.order,
    --       },
    --     },
    --     confirm_opts = {
    --       behavior = cmp.ConfirmBehavior.Replace,
    --       select = false,
    --     },
    --     window = {
    --       completion = cmp.config.window.bordered({
    --         winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    --       }),
    --       documentation = cmp.config.window.bordered({
    --         winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    --       }),
    --     },
    --     experimental = {
    --       ghost_text = true,
    --     },
    --     performance = {
    --       max_view_entries = 100,
    --     },
    --   })
    -- end,

    -- opts = function(_, opts)
    --   local luasnip = require("luasnip")
    --   local cmp = require("cmp")
    --
    --   cmp.setup.cmdline(":", {
    --     mapping = cmp.mapping.preset.cmdline({
    --       ["<Tab>"] = cmp.mapping({
    --         c = function()
    --           cmp.confirm({
    --             behavior = cmp.ConfirmBehavior.Replace,
    --             select = true,
    --           })
    --         end,
    --       }),
    --     }),
    --     sources = cmp.config.sources({
    --       { name = "path" },
    --     }, {
    --       {
    --         name = "cmdline",
    --         option = {
    --           ignore_cmds = { "Man", "!" },
    --         },
    --       },
    --     }),
    --   })
    --
    --
    --   opts.mapping = vim.tbl_extend("force", opts.mapping, {
    --     ["<CR>"] = cmp.mapping({
    --       i = function(fallback)
    --         if cmp.visible() and cmp.get_active_entry() then
    --           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
    --         else
    --           fallback()
    --         end
    --       end,
    --       -- s = cmp.mapping.confirm({ select = true }),
    --       -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    --     }),
    --     ["<C-e>"] = function()
    --       if cmp.visible() then
    --         cmp.abort()
    --       else
    --         cmp.complete()
    --       end
    --     end,
    --     ["<Tab>"] = cmp.mapping(function(fallback)
    --       if cmp.visible() then
    --         cmp.confirm({
    --           behavior = cmp.ConfirmBehavior.Replace,
    --           select = true,
    --         })
    --       elseif luasnip.expand_or_locally_jumpable() then
    --         luasnip.expand_or_jump()
    --       else
    --         -- vim.api.nvim_replace_termcodes("<Plug>(TaboutBack)", true, true, true)
    --         fallback()
    --       end
    --     end, { "i", "s" }),
    --     ["<C-n>"] = cmp.mapping({
    --       c = function()
    --         if cmp.visible() then
    --           cmp.select_next_item()
    --         else
    --           cmp.complete()
    --         end
    --       end,
    --       -- c = function()
    --       --   if cmp.visible() then
    --       --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --       --   else
    --       --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
    --       --   end
    --       -- end,
    --       i = function(fallback)
    --         if cmp.visible() then
    --           cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --         else
    --           fallback()
    --         end
    --       end,
    --     }),
    --     ["<C-p>"] = cmp.mapping({
    --       -- c = function()
    --       --   if cmp.visible() then
    --       --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    --       --   else
    --       --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
    --       --   end
    --       -- end,
    --       i = function(fallback)
    --         if cmp.visible() then
    --           cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    --         else
    --           fallback()
    --         end
    --       end,
    --     }),
    --   })
    --
    --   table.insert(opts.sources, {
    --     name = "emoji",
    --   })
    --
    --   --
    --   --   local compare = require("cmp.config.compare")
    --   --
    --   --   local remove_source = { "luasnip", "copilot", "codeium" }
    --   --   for i, source in ipairs(opts.sources) do
    --   --     if vim.tbl_contains(remove_source, source.name) then
    --   --       table.remove(opts.sources, i)
    --   --     end
    --   --   end
    --   --
    --   --   table.insert(opts.sources, {
    --   --     name = "codeium",
    --   --     -- group_index = 1,
    --   --     -- priority = 100,
    --   --   })
    --   --
    --   --   table.insert(opts.sources, {
    --   --     name = "copilot",
    --   --     group_index = nil,
    --   --     --   -- priority = 100,
    --   --   })
    --   --   table.insert(opts.sources, {
    --   --     name = "luasnip",
    --   --     -- group_index = 1,
    --   --     -- priority = 120,
    --   --   })
    --   --   table.insert(opts.sources, { name = "emoji" })
    --   --
    --   --   -- local a = vim.tbl_extend("force", opts.sources, {
    --   --   -- })
    --   --   -- table.insert(opts.sources, 1, {
    --   --   --   name = "copilot",
    --   --   --   group_index = 1,
    --   --   --   priority = 100,
    --   --   -- })
    --   --   --
    --   --   -- table.insert(opts.sources, {
    --   --   --   name = "luasnip",
    --   --   --   group_index = 1,
    --   --   --   priority = 120,
    --   --   -- })
    --   --
    --   --   opts.sorting = {
    --   --     priority_weight = 1,
    --   --     comparators = {
    --   --       compare.length,
    --   --       compare.offset,
    --   --       compare.exact,
    --   --       -- compare.scopes,
    --   --       compare.score,
    --   --       compare.recently_used,
    --   --       compare.locality,
    --   --       compare.kind,
    --   --       -- compare.sort_text,
    --   --       compare.order,
    --   --     },
    --   --   }
    -- end,
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<C-Q>",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "]g",
        function()
          require("gitsigns").next_hunk()
        end,
        desc = "Next Git Hunk",
      },

      {
        "[g",
        function()
          require("gitsigns").prev_hunk()
        end,
        desc = "Next Git Hunk",
      },
      {
        "<leader>gA",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Stage Buffer",
      },
      {
        "<leader>ga",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Stage Hunk",
        mode = { "n", "v" },
      },
      {
        "<leader>gr",
        function()
          require("gitsigns").reset_hunk()
        end,
        desc = "Reset Hunk",
        mode = "v",
      },
      {
        "<leader>ghb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame Line",
      },
      -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      {
        "vgh",
        function()
          require("gitsigns").select_hunk()
        end,
        desc = "Select Hunk",
      },
    },
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme tokyonight]])
  --
  --     local present, tokyonight = pcall(require, "tokyonight")
  --     if not present then
  --       return
  --     end
  --     local c = require("tokyonight.colors").setup()
  --
  --     tokyonight.setup({
  --       style = "night",
  --       transparent = false, -- Enable this to disable setting the background color
  --       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  --       styles = {
  --         -- Style to be applied to different syntax groups
  --         -- Value is any valid attr-list value `:help attr-list`
  --         comments = "NONE",
  --         keywords = "italic",
  --         functions = "NONE",
  --         variables = "NONE",
  --         -- Background styles. Can be "dark", "transparent" or "normal"
  --         sidebars = "dark", -- style for sidebars, see below
  --         floats = "dark", -- style for floating windows
  --       },
  --       sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  --       day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  --       hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  --       dim_inactive = false, -- dims inactive windows
  --       lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
  --       --- You can override specific color groups to use other groups or a hex color
  --       --- function will be called with a ColorScheme table
  --       on_colors = function(colors)
  --         colors.border = "#1A1B26"
  --       end,
  --       --- You can override specific highlights to use other groups or a hex color
  --       --- function will be called with a Highlights and ColorScheme table
  --       -- on_highlights = function(highlights, colors) end,
  --       on_highlights = function(hl, _color)
  --         local prompt = "#FFA630"
  --         local text = "#488dff"
  --         local none = "NONE"
  --
  --         hl.TelescopeTitle = {
  --           fg = prompt,
  --         }
  --         hl.TelescopeNormal = {
  --           bg = none,
  --           fg = none,
  --         }
  --         hl.TelescopeBorder = {
  --           bg = none,
  --           fg = text,
  --         }
  --         hl.TelescopeMatching = {
  --           fg = prompt,
  --         }
  --         hl.MsgArea = {
  --           fg = c.fg_dark,
  --         }
  --       end,
  --     })
  --
  --     -- Completion Menu Colors
  --     local highlights = {
  --       CmpItemAbbr = { fg = c.dark3, bg = "NONE" },
  --       CmpItemKindClass = { fg = c.orange },
  --       CmpItemKindConstructor = { fg = c.purple },
  --       CmpItemKindFolder = { fg = c.blue2 },
  --       CmpItemKindFunction = { fg = c.blue },
  --       CmpItemKindInterface = { fg = c.teal, bg = "NONE" },
  --       CmpItemKindKeyword = { fg = c.magneta2 },
  --       CmpItemKindMethod = { fg = c.red },
  --       CmpItemKindReference = { fg = c.red1 },
  --       CmpItemKindSnippet = { fg = c.dark3 },
  --       CmpItemKindVariable = { fg = c.cyan, bg = "NONE" },
  --       CmpItemKindText = { fg = "LightGrey" },
  --       CmpItemMenu = { fg = "#C586C0", bg = "NONE" },
  --       CmpItemAbbrMatch = { fg = "#569CD6", bg = "NONE" },
  --       CmpItemAbbrMatchFuzzy = { fg = "#569CD6", bg = "NONE" },
  --     }
  --
  --     vim.api.nvim_set_hl(0, "CmpBorderedWindow_FloatBorder", { fg = c.blue0 })
  --
  --     for group, hl in pairs(highlights) do
  --       vim.api.nvim_set_hl(0, group, hl)
  --     end
  --   end,
  -- },
}
