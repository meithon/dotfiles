local status, mason_null_ls = pcall(require, "mason-null-ls")
---
-- mason setting
---
if not status then
	print("mason-null-ls is not found")
end

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

-- Merge formatter and linter into one table
local formatter_linter = formatter
for I = 1, #linter do
	formatter_linter[#formatter + I] = linter[I]
end

mason_null_ls.setup({
	ensure_installed = formatter_linter,
})
---
-- null_ls setting
---
local null_ls_status, null_ls = pcall(require, "null-ls")
if not null_ls_status then
	print("null-ls is not found")
end

local null_sources = function()
	local source_return = {}

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

-- auto format setting
local async_formatting = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textdocument/formatting",
		vim.lsp.util.make_formatting_params({}),
		function(err, res, ctx)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				-- you can modify the log message / level (or ignore it completely)
				vim.notify("formatting: " .. err_msg, vim.log.levels.warn)
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
local augroup = vim.api.nvim_create_augroup("lspformatting", {})

null_ls.setup({
	on_attach = function(client, bufnr)
		-- if client.supports_method("textdocument/formatting") then
		if client.server_capabilities.documentformattingprovider then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("bufwritepre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					async_formatting(bufnr)
				end,
			})
		end
	end,
	sources = null_sources(),
})
