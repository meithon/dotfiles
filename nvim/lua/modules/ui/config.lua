local config = {}

function config.tabline()
	require("tabline").setup({
		options = {
			show_tabs_always = true,
			show_filename_only = true,
			modified_icon = "+ ",
		},
	})
	vim.cmd([[
      set guioptions-=e " Use showtabline in gui vim
      set sessionoptions+=tabpages,globals " store tabpages and globals in session
    ]])
end

function config.noice()
	require("noice").setup({
		messages = {
			enabled = false,
		},
		cmdline = {
			enabled = false,
		},
		lsp = {
			signature = {
				enabled = false,
			},
		},
	})

	vim.notify = require("notify")
end

function config.wilder()
	local wilder = require("wilder")
	wilder.setup({ modes = { ":", "/", "?" } })
	-- Disable Python remote plugin
	wilder.set_option("use_python_remote_plugin", 0)

	wilder.set_option("pipeline", {
		wilder.branch(
			wilder.cmdline_pipeline({
				fuzzy = 1,
				fuzzy_filter = wilder.lua_fzy_filter(),
			}),
			wilder.search_pipeline()
		),
	})

	wilder.set_option(
		"renderer",
		wilder.popupmenu_renderer({
			highlighter = {
				wilder.lua_fzy_highlighter(), -- requires fzy-lua-native vim plugin found
				-- at https://github.com/romgrk/fzy-lua-native
			},
			highlights = {
				accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }),
			},
			left = { " ", wilder.popupmenu_devicons() },
			right = { " ", wilder.popupmenu_scrollbar() },
		})
	)
end

function config.indent_blankline()
	vim.opt.list = true
	--vim.opt.listchars:append "space:⋅"
	vim.opt.listchars:append("eol:↴")

	vim.g.indent_blankline_filetype_exclude = { "startify" }
	require("indent_blankline").setup({
		space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = true,
	})
end

function config.startify()
	local ascii = {
		"███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
		"████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
		"██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
		"██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
		"██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
		"╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
	}

	local center = vim.fn["startify#center"]
	vim.g.startify_custom_header = center(ascii)

	vim.g.startify_padding_left = math.floor((vim.fn.winwidth(0) - 70) / 2)
end

function config.lualine()
	require("lualine").setup({
		options = {
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {
				{
					"filename",
					file_status = true, -- displays file status (readonly status, modified status)
					path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
				},
			},
			lualine_x = {
				{
					sources = { "nvim_diagnostic" },
					"diagnostics",
					symbols = {
						error = " ",
						warn = " ",
						info = " ",
						hint = " ",
					},
				},
				"encoding",
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		extensions = { "fugitive" },
	})
end

function config.bufferline()
	require("bufferline").setup({
		options = {
			custom_filter = function(buf_number)
				if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
					return true
				end
			end,
			number = "none",
			indicator = {
				icon = "▎", -- this should be omitted if indicator style is not 'icon'
				style = "icon", -- | 'underline' | 'none',
			},
			modified_icon = "●",
			buffer_close_icon = "",
			left_trunc_marker = "",
			right_trunc_marker = "",
			max_name_length = 18,
			max_prefix_length = 13,
			tab_size = 18,
			show_buffer_close_icons = false,
			show_buffer_icons = true,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
			always_show_bufferline = true,
			separator_style = "thick",
			offsets = {
				{
					filetype = "vfiler",
					text_align = "center",
					text = "File Explorer",
					padding = 1,
				},
			},
		},
	})
end

function config.treesitter()
	require("nvim-treesitter.configs").setup({
		-- A list of parser names, or "all"
		ensure_installed = { "json", "html", "javascript", "typescript", "lua", "astro", "go", "vim", "css", "scss" },

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
		rainbow = {
			enable = true,
			-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
			extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = nil, -- Do not enable for files with more than n lines, int
			-- colors = {}, -- table of hex strings
			-- termcolors = {} -- table of colour name strings
		},
		markid = { enable = true },
		matchup = {
			enable = true,
		},
	})
end

return config
