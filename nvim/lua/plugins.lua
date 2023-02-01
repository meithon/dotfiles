return {
	----------------------
	-- completion
	----------------------
	{
		"neoclide/coc.nvim",
		branch = "release",
		config = function()
			vim.g.coc_global_extension = {
				"coc-tsserver",
				"coc-prettier",
				"coc-eslint",
				"coc-css",
				"coc-emmet",
				"coc-html",
				"coc-json",

				"coc-react-refactor",

				"coc-snippets",
				"coc-tabnine",
				"coc-sql",

				"coc-go",
				"coc-restclient",
			}
			-- Some servers have issues with backup files, see #649
			vim.opt.backup = false
			vim.opt.writebackup = false

			-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
			-- delays and poor user experience
			vim.opt.updatetime = 300

			-- Always show the signcolumn, otherwise it would shift the text each time
			-- diagnostics appeared/became resolved
			vim.opt.signcolumn = "yes"

			local keyset = vim.keymap.set
			-- Autocomplete
			function _G.check_back_space()
				local col = vim.fn.col(".") - 1
				return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
			end

			-- Use Tab for trigger completion with characters ahead and navigate
			-- NOTE: There's always a completion item selected by default, you may want to enable
			-- no select by setting `"suggest.noselect": true` in your configuration file
			-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
			-- other plugins before putting this into your config
			local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
			keyset(
				"i",
				"<TAB>",
				'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
				opts
			)
			keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

			-- Make <CR> to accept selected completion item or notify coc.nvim to format
			-- <C-g>u breaks current undo, please make your own choice

			keyset(
				"i",
				"<cr>",
				[[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
				opts
			)

			-- Use <c-j> to trigger snippets

			keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
			-- Use <c-space> to trigger completion
			keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

			-- Use K to show documentation in preview window
			function _G.show_docs()
				local cw = vim.fn.expand("<cword>")
				if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
					vim.api.nvim_command("h " .. cw)
				elseif vim.api.nvim_eval("coc#rpc#ready()") then
					vim.fn.CocActionAsync("doHover")
				else
					vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
				end
			end

			-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
			vim.api.nvim_create_augroup("CocGroup", {})
			vim.api.nvim_create_autocmd("CursorHold", {
				group = "CocGroup",
				command = "silent call CocActionAsync('highlight')",
				desc = "Highlight symbol under cursor on CursorHold",
			})

			-- Formatting selected code
			-- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
			-- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

			-- Setup formatexpr specified filetype(s)
			vim.api.nvim_create_autocmd("FileType", {
				group = "CocGroup",
				pattern = "typescript,json",
				command = "setl formatexpr=CocAction('formatSelected')",
				desc = "Setup formatexpr specified filetype(s).",
			})

			-- Update signature help on jump placeholder
			vim.api.nvim_create_autocmd("User", {
				group = "CocGroup",
				pattern = "CocJumpPlaceholder",
				command = "call CocActionAsync('showSignatureHelp')",
				desc = "Update signature help on jump placeholder",
			})

			-- Apply codeAction to the selected region
			-- Example: `<leader>aap` for current paragraph
			local opts = { silent = true, nowait = true }
			keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
			keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

			-- Remap keys for apply code actions at the cursor position.
			keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
			-- Remap keys for apply code actions affect whole buffer.
			keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
			-- Apply the most preferred quickfix action on the current line.
			keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

			-- Remap keys for apply refactor code actions.
			keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
			keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
			keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

			-- Run the Code Lens actions on the current line
			keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

			-- Map function and class text objects
			-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
			keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
			keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
			keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
			keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
			keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
			keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
			keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
			keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

			-- Remap <C-f> and <C-b> to scroll float windows/popups
			---@diagnostic disable-next-line: redefined-local
			local opts = { silent = true, nowait = true, expr = true }
			keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
			keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
			keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
			keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
			keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
			keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

			-- Add `:Format` command to format current buffer
			vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

			-- " Add `:Fold` command to fold current buffer
			vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

			-- Add `:OR` command for organize imports of the current buffer
			vim.api.nvim_create_user_command(
				"OR",
				"call CocActionAsync('runCommand', 'editor.action.organizeImport')",
				{}
			)
		end,
	},

	----------------------
	-- editor
	----------------------
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
		keys = { "gc" },
		config = true,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ "nacro90/numb.nvim", config = true, event = "CmdwinEnter" },

	{ "junegunn/vim-easy-align", keys = { "<Plug>(EasyAlign)" } },
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
				mapping = { "jk" }, -- a table with mappings to use
				timeout = 200, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				clear_empty_lines = false, -- clear line after escaping if there is only whitespace
				keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
			})
		end,
	},
	{
		"machakann/vim-sandwich",
		dependencies = { "vim-wordmotion" },
		keys = { "sa", "sd", "sr" },
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
	----------------------
	-- tool
	----------------------
	{
		"bayne/vim-dot-http",
		lazy = true,
		ft = "http",
		cmd = "DotHttp",
		config = function()
			vim.g.dot_http_env = "dev"
		end,
	},
	{
		"numToStr/FTerm.nvim",
		lazy = true,
		cmd = { "FTermOpen", "FTermClose", "FTermClose" },
		config = function()
			require("FTerm").setup({
				border = "double",
				dimensions = {
					height = 0.9,
					width = 0.9,
				},
			})

			-- create command
			vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
			vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
			vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "InsertLeave",
		config = function()
			require("which-key").setup({
				key_labels = {
					["<space>"] = "<SPACE>",
					["<CR>"] = "<ENTER>",
					["<Tab>"] = "<TAB>",
				},
				triggers = { "<leader>" }, -- If not written, conflict with vfiler to cause error occurs
				disable = {
					buftypes = { "vfiler", "nofile" },
					filetypes = { "vfiler", "nofile" },
				},
			})
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		cmd = { "Lspsaga" },
		module = { "lspsaga.diagnostic" },
		config = true,
	},
	{
		"kkvh/vim-docker-tools",
		cmd = "DockerToolsOpen",
	},
	{
		"thinca/vim-qfreplace",
		event = "QuickFixCmdPost",
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				auto_enable = true,
				auto_resize_height = true, -- highly recommended enable
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
					show_title = false,
					should_preview_cb = function(bufnr, qwinid)
						local ret = true
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						local fsize = vim.fn.getfsize(bufname)
						if fsize > 100 * 1024 then
							-- skip file size greater than 100k
							ret = false
						elseif bufname:match("^fugitive://") then
							-- skip fugitive buffer
							ret = false
						end
						return ret
					end,
				},
				-- make `drop` and `tab drop` to become preferred
				func_map = {
					drop = "o",
					openc = "O",
					split = "<C-s>",
					tabdrop = "<C-t>",
					-- set to empty string to disable
					tabc = "",
					ptogglemode = "z,",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{
		"uga-rosa/ccc.nvim",

		cmd = { "CccPick" },
		config = function()
			local ColorInput = require("ccc.input")
			local convert = require("ccc.utils.convert")

			local RgbHslCmykInput = setmetatable({
				name = "RGB/HSL/CMYK",
				max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
				min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
				delta = { 1 / 255, 1 / 255, 1 / 255, 1, 0.01, 0.01, 0.005, 0.005, 0.005, 0.005 },
				bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
			}, { __index = ColorInput })

			function RgbHslCmykInput.format(n, i)
				if i <= 3 then
					-- RGB
					n = n * 255
				elseif i == 5 or i == 6 then
					-- S or L of HSL
					n = n * 100
				elseif i >= 7 then
					-- CMYK
					return ("%5.1f%%"):format(math.floor(n * 200) / 2)
				end
				return ("%6d"):format(n)
			end

			function RgbHslCmykInput.from_rgb(RGB)
				local HSL = convert.rgb2hsl(RGB)
				local CMYK = convert.rgb2cmyk(RGB)
				local R, G, B = unpack(RGB)
				local H, S, L = unpack(HSL)
				local C, M, Y, K = unpack(CMYK)
				return { R, G, B, H, S, L, C, M, Y, K }
			end

			function RgbHslCmykInput.to_rgb(value)
				return { value[1], value[2], value[3] }
			end

			function RgbHslCmykInput:_set_rgb(RGB)
				self.value[1] = RGB[1]
				self.value[2] = RGB[2]
				self.value[3] = RGB[3]
			end

			function RgbHslCmykInput:_set_hsl(HSL)
				self.value[4] = HSL[1]
				self.value[5] = HSL[2]
				self.value[6] = HSL[3]
			end

			function RgbHslCmykInput:_set_cmyk(CMYK)
				self.value[7] = CMYK[1]
				self.value[8] = CMYK[2]
				self.value[9] = CMYK[3]
				self.value[10] = CMYK[4]
			end

			function RgbHslCmykInput:callback(index, new_value)
				self.value[index] = new_value
				local v = self.value
				if index <= 3 then
					local RGB = { v[1], v[2], v[3] }
					local HSL = convert.rgb2hsl(RGB)
					local CMYK = convert.rgb2cmyk(RGB)
					self:_set_hsl(HSL)
					self:_set_cmyk(CMYK)
				elseif index <= 6 then
					local HSL = { v[4], v[5], v[6] }
					local RGB = convert.hsl2rgb(HSL)
					local CMYK = convert.rgb2cmyk(RGB)
					self:_set_rgb(RGB)
					self:_set_cmyk(CMYK)
				else
					local CMYK = { v[7], v[8], v[9], v[10] }
					local RGB = convert.cmyk2rgb(CMYK)
					local HSL = convert.rgb2hsl(RGB)
					self:_set_rgb(RGB)
					self:_set_hsl(HSL)
				end
			end

			local ccc = require("ccc")
			local mapping = ccc.mapping

			ccc.setup({
				default_color = "#ffffff",
				inputs = {
					RgbHslCmykInput,
				},
				mappings = {
					t = mapping.toggle_alpha,
					L = mapping.increase5,
					a = mapping.increase10,
					H = mapping.decrease5,
					i = mapping.decrease10,
					I = mapping.set0,
					A = mapping.set100,
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = { "GV", "Git", "Gdiffsplit", "Gvdiffsplit" },
	},
	{
		"junegunn/gv.vim",
		cmd = { "GV" },
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeShow", "UndotreeFocus" },
	},
	{
		"nvim-telescope/telescope.nvim",
		module = { "telescope" },
		cmd = { "Telescope" },
		dependencies = {
			{ "nvim-lua/plenary.nvim", module = { "plenary" } },
			{ "nvim-lua/popup.nvim", module = { "popup" } },
		},
	},
	{
		"obaland/vfiler.vim",

		cmd = "VFiler",
		dependencies = {
			"obaland/vfiler-column-devicons",
		},
		config = function()
			require("vfiler/config").setup({
				options = {
					columns = "indent,devicons,name,git",
					auto_cd = true,
					auto_resize = true,
					keep = true,
					layout = "left",
					width = 40,
					git = {
						enabled = true,
						untracked = true,
						ignored = true,
					},
				},
			})
		end,
	},

	----------------------
	-- ui
	----------------------
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"lilydjwg/colorizer",
		priority = 1,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
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
		end,
	},
	{
		"gelguy/wilder.nvim",
		dependencies = {
			{ "romgrk/fzy-lua-native", build = "make" },
		},
		config = function()
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
						accent = wilder.make_hl(
							"WilderAccent",
							"Pmenu",
							{ { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }
						),
					},
					left = { " ", wilder.popupmenu_devicons() },
					right = { " ", wilder.popupmenu_scrollbar() },
				})
			)
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.opt.list = true
			--vim.opt.listchars:append "space:⋅"
			vim.opt.listchars:append("eol:↴")

			vim.g.indent_blankline_filetype_exclude = { "startify" }
			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	},
	{
		"mhinz/vim-startify",
		config = function()
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
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
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
		end,
	},
	{
		"kdheepak/tabline.nvim",
		config = function()
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
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"theHamsta/tree-sitter-html",
			"David-Kunz/markid",
			"windwp/nvim-ts-autotag",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"p00f/nvim-ts-rainbow",
			"andymass/vim-matchup",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"json",
					"html",
					"javascript",
					"typescript",
					"lua",
					"astro",
					"go",
					"vim",
					"css",
					"scss",
				},

				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					disable = {},
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
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = nil, -- Do not enable for files with more than n lines, int
				},
				markid = { enable = true },
				matchup = {
					enable = true,
				},
			})
		end,
	},
}
