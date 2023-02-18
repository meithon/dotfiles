return {
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
		"MeiWagatsuma/SelectEase",
		config = function()
			local select_ease = require("SelectEase")

			local lua_query = [[
            ;; query
            ((identifier) @cap)
            ("string_content" @cap)
            ((true) @cap)
            ((false) @cap)
        ]]
			local python_query = [[
            ;; query
            ((identifier) @cap)
            ((string) @cap)
        ]]
			local html_query = [[
            ;; query
            ((tag_name) @cap)
            ((text) @cap)
            ((attribute_name) @cap)
            ((attribute_value) @cap)
        ]]
			local json = [[
            ;; query
            ((number) @cap)
            ((true) @cap)
            ((false) @cap)
            ((string_content) @cap)
            
      ]]
			local js_query = [[
            ;; query
            ((number) @cap)
            ((true) @cap)
            ((false) @cap)
            ((null) @cap)
            ((string_fragment) @cap)
            ((identifier) @cap)
            ((property_identifier) @cap)
            ((shorthand_property_identifier) @cap)
      ]]
			local react_query = [[
            ((jsx_text) @cap)
        ]]
			local ts_query = [[
            ((type_identifier) @cap)
            ((predefined_type) @cap)
      ]]
			local tsx_query = js_query .. react_query .. ts_query

			local queries = {
				lua = lua_query,
				python = python_query,
				javascript = js_query .. react_query,
				tsx = tsx_query,
				typescript = js_query .. ts_query,
				html = html_query,
				json = json,
			}
			local opts = { noremap = true, silent = true }
			vim.keymap.set({ "n", "s" }, "<C-i>", function()
				select_ease.select_node({ queries = queries, direction = "previous" })
			end, opts)
			vim.keymap.set({ "n", "s" }, "<C-o>", function()
				select_ease.select_node({ queries = queries, direction = "next" })
			end, opts)
		end,
	},
	{
		"ziontee113/syntax-tree-surfer",
		dependencies = "nvim-treesitter/nvim-treesitter",
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
		keys = { "w", "e", "b", "W", "E", "B" },
	},
	{
		"hrsh7th/vim-searchx",
		keys = { "/", "?" },
		config = function()
			local g = {}

			g.auto_accept = true
			g.scrolloff = vim.g.scrolloff
			g.scrolltime = 500
			g.nohlsearch = { jump = true }
			g.markers = {
				"A",
				"B",
				"C",
				"D",
				"E",
				"F",
				"G",
				"H",
				"I",
				"J",
				"K",
				"L",
				"M",
				"N",
				"O",
				"P",
				"Q",
				"R",
				"S",
				"T",
				"U",
				"V",
				"W",
				"X",
				"Y",
				"Z",
			}

			vim.g.serachx = g
		end,
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
			{ "sa" },
			{ "sd" },
			{ "sr" },

			{ "sa", mode = "v" },
			{ "sd", mode = "v" },
			{ "sr", mode = "v" },
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
		keys = { "<C-n>" },
	},
}
