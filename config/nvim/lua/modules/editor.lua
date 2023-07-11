return {
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			vim.g.tmux_navigator_no_mappings = 1
			local kopts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap("n", "<C-w>h", ":TmuxNavigateLeft<CR>", kopts)
			vim.api.nvim_set_keymap("n", "<C-w>j", ":TmuxNavigateDown<CR>", kopts)
			vim.api.nvim_set_keymap("n", "<C-w>k", ":TmuxNavigateUp<CR>", kopts)
			vim.api.nvim_set_keymap("n", "<C-w>l", ":TmuxNavigateRight<CR>", {})
		end,
	},
	{
		-- Manage sessions
		"folke/persistence.nvim",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
		-- stylua: ignore
		config = function()
			require("persistence").setup()
			vim.api.nvim_create_user_command("RestoreLastSession", require("persistence").load, {})
		end
		,
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

			vim.keymap.set("n", "<C-w>y", [[:SmartResizeLeft20<cr>]])
			vim.keymap.set("n", "<C-w>u", [[:SmartResizeDown20<cr>]])
			vim.keymap.set("n", "<C-w>i", [[:SmartResizeUp20<cr>]])
			vim.keymap.set("n", "<C-w>o", [[:SmartResizeRight20<cr>]])
		end,
	},
	{
		"jghauser/fold-cycle.nvim",
		config = function()
			require("fold-cycle").setup({
				open_if_max_closed = true, -- closing a fully closed fold will open it
				close_if_max_opened = true, -- opening a fully open fold will close it
				softwrap_movement_fix = false, -- see below
			})

			vim.keymap.set("n", "<tab>", function()
				return require("fold-cycle").open()
			end, { silent = true, desc = "Fold-cycle: open folds" })
			vim.keymap.set("n", "<s-tab>", function()
				return require("fold-cycle").close()
			end, { silent = true, desc = "Fold-cycle: close folds" })
			vim.keymap.set("n", "zC", function()
				return require("fold-cycle").close_all()
			end, { remap = true, silent = true, desc = "Fold-cycle: close all folds" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
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
			"<C-h>",
			"<C-j>",
			"<C-k>",
			"<C-l>",
			"vp",
			"vc",
			{ "H", mode = "x" },
			{ "J", mode = "x" },
			{ "K", mode = "x" },
			{ "L", mode = "x" },
		},
		config = function()
			-- Syntax Tree Surfer

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

			-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
			vim.keymap.set("n", "<C-l>", function()
				vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
				return "g@l"
			end, { silent = true, expr = true })
			vim.keymap.set("n", "<C-h>", function()
				vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
				return "g@l"
			end, { silent = true, expr = true })

			local opts = { noremap = true, silent = true }
			-- Visual Selection from Normal Mode
			vim.keymap.set("n", "vp", "<cmd>STSSelectMasterNode<cr>", opts)
			vim.keymap.set("n", "vc", "<cmd>STSSelectCurrentNode<cr>", opts)

			-- Select Nodes in Visual Mode
			vim.keymap.set("x", "L", "<cmd>STSSelectNextSiblingNode<cr>", opts)
			vim.keymap.set("x", "H", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
			vim.keymap.set("x", "K", "<cmd>STSSelectParentNode<cr>", opts)
			vim.keymap.set("x", "J", "<cmd>STSSelectChildNode<cr>", opts)

			-------------------------------
			-- jump with limited targets --
			-- jump to sibling nodes only
			vim.keymap.set("n", "-", function()
				sts.filtered_jump({
					"if_statement",
					"else_clause",
					"else_statement",
				}, false, { destination = "siblings" })
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
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
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
	},
	{
		"kazhala/close-buffers.nvim",
		config = true,
	},
	{
		"tiagovla/scope.nvim",
		config = true,
	},
	{
		"itchyny/vim-cursorword",
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
	},
	{ "nacro90/numb.nvim", config = true, event = "CmdwinEnter" },
	{
		"godlygeek/tabular",
		cmd = "Tabularize",
		keys = { { "a ", mode = "v" }, { "a=", mode = "v" }, { "a:", mode = "v" } },
	},
	{
		"ggandor/lightspeed.nvim",
		keys = { "<Plug>Lightspeed_s", "<Plug>Lightspeed_S", "f", "F" },
		config = true,
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
		"tversteeg/registers.nvim",
		branch = "main",
		keys = { '"' },
		config = true,
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		dependencies = "kevinhwang91/nvim-hlslens",
		keys = { { "<C-n>", mode = { "v", "i", "n" } } },
		config = function()
			vim.cmd([[
        aug VMlens
          au!
          au User visual_multi_start lua require('vmlens').start()
          au User visual_multi_exit lua require('vmlens').exit()
        aug END
      ]])
		end,
	},
}
