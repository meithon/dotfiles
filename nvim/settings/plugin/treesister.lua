local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
vim.opt.runtimepath:append(parser_install_dir)

require("nvim-treesitter.configs").setup({
	parser_install_dir = parser_install_dir,
	-- A list of parser names, or "all"
	ensure_installed = "all",

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	-- List of parsers to ignore installing (for "all")

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	context_commentstring = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["ic"] = "@class.inner",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
			},
		},
		dselect = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]["] = "@function.outer",
				["]m"] = "@class.outer",
			},
			goto_next_end = {
				["]]"] = "@function.outer",
				["]M"] = "@class.outer",
			},
			goto_previous_start = {
				["[["] = "@function.outer",
				["[m"] = "@class.outer",
			},
			goto_previous_end = {
				["[]"] = "@function.outer",
				["[M"] = "@class.outer",
			},
		},
	},
	autotag = {
		enable = true,
	},
})
