local config = {}

function config.null_ls()
	local null_ls = require("null-ls")
	local null_sources = function()
		local source_return = {}
		local formatter = {
			"prettier",
			"stylua",
			"goimports",
			"black",
		}

		local linter = {
			"eslint_d",
			"luacheck",
			"revive",
			"pylint",
		}

		-- set the formatters to null-ls
		for _, package in ipairs(formatter) do
			table.insert(source_return, null_ls.builtins.formatting[package])
		end

		-- set the diagnostics to null-ls
		for _, package in ipairs(linter) do
			table.insert(source_return, null_ls.builtins.diagnostics[package])
		end
		return source_return
	end

	-- if you want to set up formatting on save, you can use this as a callback
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
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
end

function config.mason_null_ls()
	local formatter = {
		"prettier",
		"stylua",
		"luaformatter",
		"goimports",
		"black",
	}

	local linter = {
		"eslint_d",
		"luacheck",
		"revive",
		"pylint",
	}

	-- Merge formatter and linter into one table
	local formatter_linter = formatter
	for i = 1, #linter do
		table.insert(formatter_linter, linter[i])
	end

	require("mason-null-ls").setup({
		ensure_installed = formatter_linter,
	})
end

function config.mason()
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		ensure_installed = {
			"astro-language-server",
			"gopls",
			"lua-language-server",
			"typescript-language-server",
		},
	})
end

function config.mason_tool_installer()
	require("mason-tool-installer").setup({

		ensure_installed = {

			{ "bash-language-server", auto_update = true },

			"lua-language-server",
			"vim-language-server",
			"gopls",
			"stylua",
			"shellcheck",
			"editorconfig-checker",
			"gofumpt",
			"golines",
			"gomodifytags",
			"gotests",
			"impl",
			"json-to-struct",
			"luacheck",
			"misspell",
			"revive",
			"shellcheck",
			"shfmt",
			"staticcheck",
		},

		auto_update = false,

		run_on_start = false,

		start_delay = 3000, -- 3 second delay
	})
end

function config.mason_lspconfig()
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
			-- require "lsp_signature".setup({
			--   bind = true, -- This is mandatory, otherwise border config won't get registered.
			--   handler_opts = {
			--     border = "rounded"
			--   }
			-- })
		end,
	})
end

function config.cmp()
	local cmp = require("cmp")
	local lspkind = require("lspkind")

	local luasnip = require("luasnip")

	require("luasnip.loaders.from_vscode").lazy_load()
	local feedkey = function(key, mode)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
	end
	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	cmp.setup({
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				-- For `vsnip` user.
				-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

				-- For `luasnip` user.
				luasnip.lsp_expand(args.body)

				-- For `ultisnips` user.
				-- vim.fn["UltiSnips#Anon"](args.body)
			end,
		},
		mapping = {
			-- ['<C-i>'] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.abort()
				else
					cmp.complete()
				end
			end),
			["<Down>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					fallback()
				else
					cmp.complete()
				end
			end),
			["<UP>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif has_words_before() then
					fallback()
				else
					cmp.complete()
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

			-- For vsnip user.
			-- { name = 'vsnip' },

			-- For luasnip user.
			{ name = "luasnip" },

			-- For ultisnips user.
			-- { name = 'ultisnips' },

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
end

function config.luasnip()
	require("luasnip.loaders.from_vscode").lazy_load()
end

function config.tabnine()
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
end

return config
