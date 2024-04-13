local Util = require("lazyvim.util")
local icons = require("lazyvim.config").icons

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

  return function()
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then
      return ""
    end
    local root = Util.root.get({ normalize = true })
    local cwd = Util.root.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
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

---@class Plugin : OnePlugin
---@field dependencies? OnePlugin[]|OnePlugin |string[]|string

---@alias plugins.Plugin Plugin

---@type Plugin[]
return {
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
  {
    "nvim-lualine/lualine.nvim",

    opts = function(_, opts)
      opts.inactive_winbar = {
        lualine_c = {
          pretty_path({ relative = "cwd" }),
        },
      }
      opts.winbar = {

        lualine_c = {
          pretty_path({ relative = "cwd" }),
        },
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
    "L3MON4D3/LuaSnip",
    config = function()
      ---@diagnostic disable: unused-local
      local ls = require("luasnip")
      local s = ls.snippet
      -- local sn = ls.snippet_node
      local isn = ls.indent_snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local events = require("luasnip.util.events")
      local ai = require("luasnip.nodes.absolute_indexer")
      local extras = require("luasnip.extras")
      local l = extras.lambda
      local rep = extras.rep
      local p = extras.partial
      local m = extras.match
      local n = extras.nonempty
      local dl = extras.dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local conds = require("luasnip.extras.expand_conditions")
      local postfix = require("luasnip.extras.postfix").postfix
      local types = require("luasnip.util.types")
      local parse = require("luasnip.util.parser").parse_snippet
      local ms = ls.multi_snippet
      local k = require("luasnip.nodes.key_indexer").new_key
      local ts_post = require("luasnip.extras.treesitter_postfix").treesitter_postfix
      ---@diagnostic enable: unused-local

      local newline = ""
      ---------
      -- Lua
      --

      -- print()
      --
      -- function add(a, b)
      --   return a + b
      -- end.var

      ls.add_snippets("lua", {

        s("test", {
          t({ 'test("' }),
        }),
        ts_post(
          {
            matchTSNode = {
              query = [[
    (function_declaration
      name: (identifier) @fname
      parameters: (parameters) @params
      body: (block) @body
    ) @prefix
  ]],
              query_lang = "lua",
            },
            trig = ".var",
          },
          fmt(
            [[
    local {} = function{}
        {}
    end
  ]],
            {
              l(l.LS_TSCAPTURE_FNAME),
              l(l.LS_TSCAPTURE_PARAMS),
              l(l.LS_TSCAPTURE_BODY),
            }
          )
        ),
      })

      -----------
      -- Typescript
      --

      ls.add_snippets("typescript", {

        -- test("testTitle", async ({
        --   前提条件,
        --   仕向け機能,
        --   モデル機能,
        --   ソフトウェアマイルストーン機能,
        --   部番機能,
        --   リリースノート機能,
        --   ソフトウェアイメージ機能,
        --   Swallow機能,
        --   サインインページ,
        --   仕向け登録ページ,
        --   仕向け編集ページ,
        --   仕向け一覧ページ,
        --   部番登録ページ,
        --   部番一覧ページ,
        --   部番詳細ページ,
        --   部番編集ページ,
        --   ソフトウェアイメージ追加ページ,
        --   ソフトウェアイメージ編集ページ,
        --   ソフトウェアイメージ一覧ページ,
        --   ソフトウェアマイルストーン登録ページ,
        --   ソフトウェアマイルストーン編集ページ,
        --   検査詳細ページ,
        --   系図ページ,
        --   モデル登録ページ,
        --   モデル編集ページ,
        --   モデル一覧ページ,
        --   ソフトウェアマイルストーン一覧ページ,
        --   Gerritページ,
        --   Nextcloud,
        -- }) => {
        --   await 前提条件(async () => {
        --     //
        --   });
        -- });
        s("test", {
          t({ 'test("' }),
          i(1),
          t({ '"' }),
          t({ ", async ({", newline }),
          t({
            "  前提条件,",
            "  仕向け機能,",
            "  モデル機能,",
            "  ソフトウェアマイルストーン機能,",
            "  部番機能,",
            "  リリースノート機能,",
            "  ソフトウェアイメージ機能,",
            "  Swallow機能,",
            "  検査機能,",
            "  サインインページ,",
            "  仕向け登録ページ,",
            "  仕向け編集ページ,",
            "  仕向け一覧ページ,",
            "  部番登録ページ,",
            "  部番一覧ページ,",
            "  部番詳細ページ,",
            "  部番編集ページ,",
            "  ソフトウェアイメージ追加ページ,",
            "  ソフトウェアイメージ編集ページ,",
            "  ソフトウェアイメージ一覧ページ,",
            "  ソフトウェアマイルストーン登録ページ,",
            "  ソフトウェアマイルストーン編集ページ,",
            "  検査詳細ページ,",
            "  系図ページ,",
            "  モデル登録ページ,",
            "  モデル編集ページ,",
            "  モデル一覧ページ,",
            "  ソフトウェアマイルストーン一覧ページ,",
            "  Gerritページ,",
            "  Nextcloud,",
            newline,
          }),
          t({ "}) => {", newline }),
          t({ "  await 前提条件(async () => {", newline }),
          t({ "	   //", newline }),
          t({ "  });", newline }),
          t({ "});", newline }),
        }),
        s("inSorcesVitest", {
          t({ "if (import.meta.vitest) {", "	const { it, expect } = import.meta.vitest;", [[	test("]] }),
          i(1),
          t({ '" () => {', "    " }),
          i(2),
          t({ "", "	});", "}" }),
        }),
        postfix(".print", {
          d(1, function(_, parent)
            return sn(nil, { t({ "console.log(" .. parent.env.POSTFIX_MATCH .. ")", newline }) })
          end),
        }),
      })

      -- local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
      --
      -- treesitter_postfix({
      --     trig = ".mv",
      --     matchTSNode = {
      --         query = [[
      --             [
      --               (call_expression)
      --               (identifier)
      --               (template_function)
      --               (subscript_expression)
      --               (field_expression)
      --               (user_defined_literal)
      --             ] @prefix
      --         ]]
      --         query_lang = "cpp"
      --     },
      -- },{
      --     f(function(_, parent)
      --         local node_content = table.concat(parent.snippet.env.LS_TSMATCH, '\n')
      --         local replaced_content = ("std::move(%s)"):format(node_content)
      --         return vim.split(ret_str, "\n", { trimempty = false })
      --     end)
      -- })

      -- ls.add_snippets =
      ls.add_snippets("all", {
        postfix(".let", {
          d(1, function(_, parent)
            return sn(nil, { t("let " .. parent.env.POSTFIX_MATCH .. " = ") })
          end),
        }),
        s("fn", {
          t("}"),
          ---@diagnostic disable-next-line: unused-local
          f(function(args, parent, user_args)
            return "() => {" .. args[1][1] .. user_args .. "}"
          end, { 1 }, { user_args = "text" }),
          t(") => {"),
        }),
        postfix(".const", {
          d(1, function(_, parent)
            return sn(nil, { t("const " .. parent.env.POSTFIX_MATCH .. " = ") })
          end),
        }),
        --         if (import.meta.vitest) {
        --   const { it, expect } = import.meta.vitest;
        --   it("", () => {
        --   });
        -- }
        postfix(".dbg", {
          d(1, function(_, parent)
            return sn(nil, {

              -- console.log('a:', a);
              -- t({ 'console.log("' .. parent.env.POSTFIX_MATCH .. ': ", ' .. parent.env.POSTFIX_MATCH .. ")" }),
              -- console.log(JSON.stringify(a, null, 2));
              t({
                'console.log("'
                  .. parent.env.POSTFIX_MATCH
                  .. ":,"
                  .. '"JSON.stringify('
                  .. parent.env.POSTFIX_MATCH
                  .. ", null, 2));",
              }),
            })
          end),
        }),
      }, {
        key = "all",
      })
    end,
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },

    ---@param opts table
    opts = function(_, opts)
      opts.ring.history_length = 10
    end,
    setup = function()
      require("yanky").setup({})
    end,
    --   highlight = { timer = 250 },
    --   ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    -- },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        {
          function()
            return Util.root.cwd()
          end,
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "David-Kunz/markid",
      "windwp/nvim-ts-autotag",
    },
    opts = function(_, opts)
      opts.markid = {
        enable = true,
      }
      opts.autotag = {
        enable = true,
      }
    end,
  },
  { -- Add vitest runner
    "rcarriga/neotest",
    dependencies = {
      -- "marilari88/neotest-vitest",
      -- "rneithon/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      -- table.insert(opts.adapters, require("neotest-vitest"))
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
      -- opts.window.mappings["H"] = "close_all_nodes"
      local mappings = vim.tbl_extend("force", opts.window.mappings, {
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
        -- ["h"] = function(state)
        --   local node = state.tree:get_node()
        --   if node.type == "directory" and node:is_expanded() then
        --     require("neo-tree.sources.filesystem").toggle_directory(state, node)
        --   else
        --     require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        --   end
        -- end,
      })
      opts.window.mappings = mappings
    end,
  },
  { -- add window picker to neo-tree
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
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
  -- },
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
        { "vs", df("", "master"), mode = "n", desc = "Flash then Select" },
        { "Vs", df("", "current"), mode = "n", desc = "Flash then Select" },
        { "Ds", df("d", "master"), mode = "n", desc = "Select Master Node then Delete" },
        { "ys", df("y", "master"), mode = "n", desc = "Select Master Node then Yank" },
        { "Xs", df("x", "current"), mode = "n", desc = "Select Node then Dlete (not yank)" },
        { "ds", df("d", "current"), mode = "n", desc = "Select Node then Delete" },
        { "Ys", df("y", "current"), mode = "n", desc = "Select Node then Yank" },
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
  -- Disable code context
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
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

    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

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

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          -- s = cmp.mapping.confirm({ select = true }),
          -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
        ["<C-e>"] = function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            -- vim.api.nvim_replace_termcodes("<Plug>(TaboutBack)", true, true, true)
            fallback()
          end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
          -- c = function()
          --   if cmp.visible() then
          --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          --   else
          --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
          --   end
          -- end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
        ["<C-p>"] = cmp.mapping({
          -- c = function()
          --   if cmp.visible() then
          --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          --   else
          --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
          --   end
          -- end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
      })

      table.insert(opts.sources, {
        name = "emoji",
      })
      table.insert(opts.sources, {
        name = "luasnip",
      })

      --
      --   local compare = require("cmp.config.compare")
      --
      --   local remove_source = { "luasnip", "copilot", "codeium" }
      --   for i, source in ipairs(opts.sources) do
      --     if vim.tbl_contains(remove_source, source.name) then
      --       table.remove(opts.sources, i)
      --     end
      --   end
      --
      --   table.insert(opts.sources, {
      --     name = "codeium",
      --     -- group_index = 1,
      --     -- priority = 100,
      --   })
      --
      --   table.insert(opts.sources, {
      --     name = "copilot",
      --     group_index = nil,
      --     --   -- priority = 100,
      --   })
      --   table.insert(opts.sources, {
      --     name = "luasnip",
      --     -- group_index = 1,
      --     -- priority = 120,
      --   })
      --   table.insert(opts.sources, { name = "emoji" })
      --
      --   -- local a = vim.tbl_extend("force", opts.sources, {
      --   -- })
      --   -- table.insert(opts.sources, 1, {
      --   --   name = "copilot",
      --   --   group_index = 1,
      --   --   priority = 100,
      --   -- })
      --   --
      --   -- table.insert(opts.sources, {
      --   --   name = "luasnip",
      --   --   group_index = 1,
      --   --   priority = 120,
      --   -- })
      --
      --   opts.sorting = {
      --     priority_weight = 1,
      --     comparators = {
      --       compare.length,
      --       compare.offset,
      --       compare.exact,
      --       -- compare.scopes,
      --       compare.score,
      --       compare.recently_used,
      --       compare.locality,
      --       compare.kind,
      --       -- compare.sort_text,
      --       compare.order,
      --     },
      --   }
    end,
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
