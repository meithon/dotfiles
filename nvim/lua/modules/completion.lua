local global = require("core.global")

if global.enable_coc then
	return {
		{
			"neoclide/coc.nvim",
			branch = "release",
			config = function()
				vim.g.coc_config_home = "$HOME/dotfiles/nvim"
				vim.g.coc_global_extension = {
					"coc-tabnine",
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
					"coc-lua",
					"coc-sumneko-lua",
				}
				-- Some servers have issues with backup files, see #649
				vim.opt.backup = false
				vim.opt.writebackup = false

				-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
				-- delays and poor user experience:
				vim.opt.updatetime = 300

				-- Always show the signcolumn, otherwise it would shift the text each time
				-- diagnostics appeared/became resolved
				vim.opt.signcolumn = "yes"

				-- Autocomplete
				function _G.check_back_space()
					local col = vim.fn.col(".") - 1
					return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
				end

				local keyset = vim.keymap.set
				local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
				keyset(
					"i",
					"<TAB>",
					'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
					opts
				)
				keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
				vim.g.coc_snippet_next = "<Tab>"
				vim.g.coc_snippet_prev = "<S-Tab>"

				keyset("i", "<CR>", [[coc#pum#visible()?coc#pum#confirm():"\<CR>"]], opts)

				-- Use <c-j> to trigger snippets
				-- Use <c-space> to trigger completion
				keyset("i", "<C-space>", "coc#refresh()", { silent = true, expr = true })
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
	}
end

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		module = { "cmp" },
		dependencies = {
			{ "onsails/lspkind.nvim", module = { "lspkind" } },
			{ "lukas-reineke/cmp-under-comparator" },
			{ "saadparwaiz1/cmp_luasnip" },
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{ "hrsh7th/cmp-nvim-lsp", module = { "cmp_nvim_lsp" } },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "andersevenrud/cmp-tmux" },
			{ "hrsh7th/cmp-path" },
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-buffer" },
			{ "kdheepak/cmp-latex-symbols" },
			{
				"tzachar/cmp-tabnine",
				build = "./install.sh",
				config = function()
					require("cmp_tabnine.config").setup({
						max_lines = 1000,
						max_num_results = 20,
						sort = true,
						run_on_every_keystroke = true,
						snippet_placeholder = "..",
						ignored_file_types = {
							-- default is not to ignore
							-- uncomment to ignore in lua:
							-- lua = true
						},
						show_prediction_strength = false,
					})
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			local feedkey = function(key, mode)
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
			end
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-e>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.abort()
						else
							cmp.complete()
						end
					end),
					["<C-n>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end),
					["<C-p>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Insert,
								select = true,
							})
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "spell" },
					{ name = "luasnip", option = { use_show_condition = false } },
					{ name = "cmp_tabnine" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "treesitter" },
				},
				formatting = {
					format = lspkind.cmp_format({
						with_text = true, -- do not show text alongside icons
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						before = function(entry, vim_item)
							vim_item.menu = ({
								nvim_lsp = "[LSP]",
								vsnip = "[Snippet]",
								nvim_lua = "[Nvim Lua]",
								buffer = "[Buffer]",
								cmp_tabnine = "[TN]",
								spell = "[Spell]",
								luasnip = "[LuaSnip]",
							})[entry.source.name]

							vim_item.dup = ({
								vsnip = 0,
								nvim_lsp = 0,
								nvim_lua = 0,
								buffer = 0,
							})[entry.source.name] or 0
							return vim_item
						end,
					}),
				},
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "InsertEnter",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			local globals = require("core.global")
			local formatter = globals.fotmatter
			local linter = globals.linter
			local null_ls = require("null-ls")
			local null_sources = function()
				local source_return = {}

				-- set the formatters to null-ls
				for _, package in ipairs(formatter) do
					if package == "prettier" then
						table.insert(
							source_return,
							null_ls.builtins.formatting.prettier.with({
								filetypes = {
									"javascript",
									"javascriptreact",
									"typescript",
									"typescriptreact",
									"vue",
									"astro",
								},
							})
						)
					else
						table.insert(source_return, null_ls.builtins.formatting[package])
					end
				end

				-- set the diagnostics to null-ls
				for _, package in ipairs(linter) do
					if package == "eslint_d" then
						table.insert(
							source_return,
							null_ls.builtins.diagnostics.eslint_d.with({
								filetypes = {
									"javascript",
									"javascriptreact",
									"typescript",
									"typescriptreact",
									"vue",
									"astro",
								},
							})
						)
					else
						table.insert(source_return, null_ls.builtins.diagnostics[package])
					end
				end
				return source_return
			end

			-- if you want to set up formatting on save, you can use this as a callback
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				diagnostics_format = "#{m} (#{s}: #{c})",
				on_attach = function(client, bufnr)
					if client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									bufnr = bufnr,
									async = true,
									filter = function(client)
										return client.name == "null-ls"
									end,
								})
								vim.notify("formatted")
							end,
						})
					end
				end,
				sources = null_sources(),
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = "MasonToolsInstall",
		config = function()
			require("mason-tool-installer").setup({

				ensure_installed = {
					"css-lsp",
					"eslint_d",
					"html-lsp",
					"lua-language-server",
					"luacheck",
					"prettier",
					"stylua",
					"typescript-language-server",
				},

				auto_update = false,

				run_on_start = false,

				start_delay = 3000, -- 3 second delay
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "BufReadPre",
		dependencies = {
			{ "neovim/nvim-lspconfig", module = "lspconfig" },
			{ "ray-x/lsp_signature.nvim", module = "lsp_signature" },
		},
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server) -- default handler (optional)
					local opt = {
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						},
					}
					require("lspconfig")[server].setup(opt)
					require("lsp_signature").setup({
						hint_enable = false,
					})
				end,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
	},
}
