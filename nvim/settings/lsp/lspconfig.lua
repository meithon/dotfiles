local status, mason = pcall(require, "mason")
if not status then
	return
end
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local null_ls = require("null-ls")

local mason_package = require("mason-core.package")
local mason_registry = require("mason-registry")

local null_sources = {}

for _, package in ipairs(mason_registry.get_installed_packages()) do
	local package_categories = package.spec.categories[1]
	if package_categories == mason_package.Cat.Formatter then
		if package.name == "prettier" then
			table.insert(null_sources, null_ls.builtins.formatting.prettier.with({ extra_filetypes = { "astro" } }))
		else
			table.insert(null_sources, null_ls.builtins.formatting[package.name])
		end
	end
	if package_categories == mason_package.Cat.Linter then
		table.insert(
			null_sources,
			null_ls.builtins.diagnostics[package.name].with({
				"[" .. package.name .. "] #{m}\n(#{c})",
			})
		)
	end
end

local async_formatting = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		vim.lsp.util.make_formatting_params({}),
		function(err, res, ctx)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				-- you can modify the log message / level (or ignore it completely)
				vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
				return
			end

			-- don't apply results if buffer is unloaded or has been modified
			if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
				return
			end

			if res then
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	on_attach = function(client, bufnr)
		-- if client.supports_method("textDocument/formatting") then
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					async_formatting(bufnr)
				end,
			})
		end
	end,
	sources = null_sources,
})

local status, lspconfig = pcall(require, "mason-lspconfig")
if not status then
	return
end

lspconfig.setup_handlers({
	function(server) -- default handler (optional)
		local opt = {
			-- -- Function executed when the LSP server startup
			-- on_attach = function(client, bufnr)
			--   local opts = { noremap=true, silent=true }
			--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
			--   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
			-- end,
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		}
		require("lspconfig")[server].setup(opt)
	end,
})
