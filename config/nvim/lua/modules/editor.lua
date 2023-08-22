local keybind = require("core.keybind").editor

return {
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "QQ",
        function()
          local buf = vim.api.nvim_get_current_buf()
          require("mini.bufremove").delete(buf, true)
        end,
        desc = "Close buffer like a VSCode",
        mode = { "n" },
      },
    },
  },
    "ziontee113/neo-minimap",
    config = function()
      -- for shorthand usage
      local nm = require("neo-minimap")
      nm.source_on_save("/home/ziontee113/.config/nvim/lua/plugins/neo-minimap/")

      nm.setup_defaults({
        height_toggle = { 40, 85 },
        hl_group = "DiagnosticWarn",
        width = 120,
        height = 40,
      })

      -- Rust -----------------------------------------------------------------------------------------------------------
      -- Definition
      nm.set({ "zd" }, "*.rs", {
        events = { "BufEnter" },
        query = {
          --     [[
          -- 	;; query
          -- 	;; (impl_item (type_identifier) @cap)
          -- 	((impl_item) @cap)
          -- 	(function_item (identifier) @cap)
          -- ]],
          [[
          	;; query
          	(mod_item (identifier) @cap)
						(static_item (identifier) @cap)
          	((impl_item) @cap)
          	(enum_item (type_identifier) @cap)
          	(function_item (identifier) @cap)
          	(struct_item (type_identifier) @cap)
          	;; (impl_item (type_identifier) @cap)
          	(macro_definition (identifier) @cap)
          ]],
          1,
        },
        regex = {},
        search_patterns = {
          { "impl", "<C-j>", true },
          { "impl", "<C-k>", false },
        },
      })

      -- Implementation
      nm.set({ "zi" }, "*.rs", {
        events = { "BufEnter" },
        query = {
          [[
          	;; query
          	;; (impl_item (type_identifier) @cap)
          	((impl_item) @cap)
          	(mod_item (identifier) @cap)
          	(function_item (identifier) @cap)
          	(macro_definition (identifier) @cap)
          ]],
          1,
        },
        regex = {},
        search_patterns = {
          { "impl", "<C-j>", true },
          { "impl", "<C-k>", false },
        },
      })

      -- Latex

      nm.set({ "zo", "zu" }, "*.tex", {
        events = { "BufEnter" },
        query = {},
        regex = {
          { [[\\section]], [[\\subsection]], [[\\subsubsection]] },
          { [[\\begin{.*}]] },
        },
      })

      -- Lua
      nm.set({ "zi", "zo", "zu" }, "*.lua", {
        events = { "BufEnter" },

        query = {
          [[
					;; query
					;; ((function_declaration name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
					;; ((function_call name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
					;; ((dot_index_expression field: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
					((function_declaration) @cap)
					((assignment_statement(expression_list((function_definition) @cap))))
					]],
          1,
          [[
					;; query
					((function_declaration) @cap)
					((assignment_statement(expression_list((function_definition) @cap))))
					((field (identifier) @cap) (#eq? @cap "keymaps"))
					]],
          [[
					;; query
					((for_statement) @cap)
					((function_declaration) @cap)
					((assignment_statement(expression_list((function_definition) @cap))))

					((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
					((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
					]],
          [[
					;; query
					((for_statement) @cap)
					((function_declaration) @cap)
					((assignment_statement(expression_list((function_definition) @cap))))
					]],
        },

        -- regex = {
        --   {},
        --   { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
        --   { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
        --   {},
        -- },

        search_patterns = {
          { "function", "<C-j>", true },
          { "function", "<C-k>", false },
          { "keymap", "<A-j>", true },
          { "keymap", "<A-k>", false },
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },

        disable_indentaion = true,
      })

      -- Typescript React
      nm.set("zi", { "typescriptreact", "javascriptreact" }, {
        query = [[
			;; query
			((function_declaration) @cap)
			((arrow_function) @cap)
			((identifier) @cap (#vim-match? @cap "^use.*"))
				]],
      })
    end,
  },
  {
    "jbyuki/instant.nvim",
    config = function()
      vim.g.instant_username = "mei"
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
    enabled = not vim.g.vscode,
    keys = {
      {
        keybind.move_left,
        ":TmuxNavigateLeft<CR>",
        desc = "Move to left buffer",
        mode = { "n" },
      },
      {
        keybind.move_down,
        ":TmuxNavigateDown<CR>",
        desc = "Move to down buffer",
        mode = { "n" },
      },
      {
        keybind.move_up,
        ":TmuxNavigateUp<CR>",
        desc = "Move to up buffer",
        mode = { "n" },
      },
      {
        keybind.move_right,
        ":TmuxNavigateRight<CR>",
        desc = "Move to right buffer",
        mode = { "n" },
      },
    },
  },
  -- {
  -- 	'rmagatti/auto-session',
  -- 	config = function()
  -- 		require("auto-session").setup {
  -- 			log_level = "error",
  -- 			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  -- 		}
  -- 	end
  -- },
  -- {
  -- 	-- Manage sessions
  -- 	"folke/persistence.nvim",
  -- 	opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
  -- 	-- stylua: ignore
  -- 	config = function()
  -- 		require("persistence").setup()
  -- 		vim.api.nvim_create_user_command("RestoreLastSession", require("persistence").load, {})
  -- 	end,
  -- },
  {
    --		'jedrzejboczar/possession.nvim',
    --		dependencies = { 'nvim-lua/plenary.nvim' },
    --		config = function()
    --			require('possession').setup {
    --				commands = {
    --					save = 'SSave',
    --					load = 'SLoad',
    --					delete = 'SDelete',
    --					list = 'SList',
    --				}
    --			}
    --			require('telescope').load_extension('possession')
    --		end
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      vim.keymap.set("n", "<leader>gl", [[:DiffviewOpen<cr>]])
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup()
    end,
    enabled = not vim.g.vscode,
    keys = {
      {
        keybind.resize_left,
        ":SmartResizeLeft20<cr>",
        desc = "Resize window left",
        mode = { "n" },
      },
      {
        keybind.resize_down,
        ":SmartResizeDown20<cr>",
        desc = "Resize window down",
        mode = { "n" },
      },
      {
        keybind.resize_up,
        ":SmartResizeUp20<cr>",
        desc = "Resize window up",
        mode = { "n" },
      },
      {
        keybind.resize_right,
        ":SmartResizeRight20<cr>",
        desc = "Resize window right",
        mode = { "n" },
      },
    },
  },
  {
    "jghauser/fold-cycle.nvim",
    config = function()
      require("fold-cycle").setup({
        open_if_max_closed = true, -- closing a fully closed fold will open it
        close_if_max_opened = true, -- opening a fully open fold will close it
        softwrap_movement_fix = false, -- see below
      })

      vim.keymap.set("n", keybind.fold_open, function()
        return require("fold-cycle").open()
      end, {
        silent = true,
        desc = "Fold-cycle: open folds",
      })
      vim.keymap.set("n", keybind.fold_close, function()
        return require("fold-cycle").close()
      end, {
        silent = true,
        desc = "Fold-cycle: close folds",
      })
      vim.keymap.set("n", "zC", function()
        return require("fold-cycle").close_all()
      end, {
        remap = true,
        silent = true,
        desc = "Fold-cycle: close all folds",
      })
    end,
    enabled = not vim.g.vscode,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    enabled = not vim.g.vscode,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    enabled = not vim.g.vscode,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      {
        "<C-h>",
        mode = "x",
      },
      "<C-j>",
      "<C-k>",
      {
        "<C-l>",
        mode = "x",
      },
      "va",
      "vi",
      { "N", mode = "x" },
      { "P", mode = "x" },
      { "K", mode = "x" },
      { "L", mode = "x" },
    },
    config = function()
      -- Syntax Tree Surfer
      local sts = require("syntax-tree-surfer")
      -- Normal Mode Swapping:
      -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
      vim.keymap.set("n", "<C-k>", function()
        vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
        return "g@l"
      end, { silent = true, expr = true })
      vim.keymap.set("n", "<C-j>", function()
        vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
        return "g@l"
      end, { silent = true, expr = true })
      vim.keymap.set("n", "sj", function() -- jump to all that you specify
        sts.targeted_jump({
          "function",
          "if_statement",
          "else_clause",
          "else_statement",
          "elseif_statement",
          "for_statement",
          "while_statement",
          "switch_statement",
        })
      end)

      -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
      vim.keymap.set("x", "<C-l>", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
        return "g@l"
      end, { silent = true, expr = true })
      vim.keymap.set("x", "<C-h>", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
        return "g@l"
      end, { silent = true, expr = true })

      local opts = { noremap = true, silent = true }
      -- Visual Selection from Normal Mode
      vim.keymap.set("n", "va", "<cmd>STSSelectMasterNode<cr>", opts)
      vim.keymap.set("n", "vi", "<cmd>STSSelectCurrentNode<cr>", opts)

      -- Select Nodes in Visual Mode
      vim.keymap.set("x", "N", "<cmd>STSSelectNextSiblingNode<cr>", opts)
      vim.keymap.set("x", "P", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
      vim.keymap.set("x", "K", "<cmd>STSSelectParentNode<cr>", opts)
      vim.keymap.set("x", "J", "<cmd>STSSelectChildNode<cr>", opts)

      -------------------------------
      -- jump with limited targets --
      -- jump to sibling nodes only
      vim.keymap.set("n", "-", function()
        sts.filtered_jump(
          {
            "if_statement",
            "else_clause",
            "else_statement",
          },
          false,
          {
            destination = "siblings",
          }
        )
      end, opts)
      vim.keymap.set("n", "=", function()
        sts.filtered_jump(
          { "if_statement", "else_clause", "else_statement" },
          true,
          { destination = "siblings" }
        )
      end, opts)

      -- jump to parent or child nodes only
      vim.keymap.set("n", "_", function()
        sts.filtered_jump({
          "if_statement",

          "else_clause",
          "else_statement",
        }, false, { destination = "parent" })
      end, opts)
      vim.keymap.set("n", "+", function()
        sts.filtered_jump({
          "if_statement",
          "else_clause",
          "else_statement",
        }, true, { destination = "children" })
      end, opts)

      require("syntax-tree-surfer").setup()
    end,
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
    },
    config = function()
      vim.o.winwidth = 5
      vim.o.winminwidth = 5
      vim.o.equalalways = false
      require("windows").setup({
        -- autowidth = {
        -- 	enable = true,
        -- 	winwidth = 40, --		        |windows.winwidth|
        -- 	filetype = { --	      |windows.autowidth.filetype|
        -- 		help = 2,
        -- 	},
        -- },
      })
    end,
    enabled = not vim.g.vscode,
  },
  {
    "samodostal/image.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
    event = "BufReadPre",
    config = function()
      require("image").setup({
        render = {
          min_padding = 5,
          show_label = true,
          use_dither = true,
          foreground_color = true,
          background_color = true,
        },
        events = {
          update_on_nvim_resize = true,
        },
      })
    end,
    enabled = not vim.g.vscode,
  },
  {
    "kazhala/close-buffers.nvim",
    config = true,
    enabled = not vim.g.vscode,
  },
  {
    "tiagovla/scope.nvim",
    config = true,
    enabled = not vim.g.vscode,
  },
  {
    "itchyny/vim-cursorword",
    enabled = not vim.g.vscode,
  },
  {
    "numToStr/Comment.nvim",
    keys = { "gc", { "gc", mode = "v" } },
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        map_cr = false, -- Avoid conflicts with CR keymap for completion
      })
    end,
    enabled = not vim.g.vscode,
  },
  {
    "nacro90/numb.nvim",
    config = true,
    event = "CmdwinEnter",
    enabled = not vim.g.vscode,
  },
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
    keys = { { "a ", mode = "v" }, { "a=", mode = "v" }, { "a:", mode = "v" } },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM",
      modes = {
        char = {
          highlight = { backdrop = false },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "chaoren/vim-wordmotion",
    keys = {
      { "w", mode = { "n", "v" } },
      { "e", mode = { "n", "v" } },
      { "b", mode = { "n", "v" } },
      { "W", mode = { "n", "v" } },
      { "E", mode = { "n", "v" } },
      { "B", mode = { "n", "v" } },
    },
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mapping = { "jk", "kj" }, -- a table with mappings to use
        timeout = 200, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
      })
    end,
    enabled = not vim.g.vscode,
  },
  {
    "machakann/vim-sandwich",
    dependencies = { "vim-wordmotion" },
    keys = {
      { "sa", mode = { "v", "n" } },
      { "sd", mode = { "v", "n" } },
      { "sr", mode = { "v", "n" } },
    },
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = { { "<C-n>", mode = { "v", "i", "n" } } },
    config = function() end,
    enabled = not vim.g.vscode,
  },
}
