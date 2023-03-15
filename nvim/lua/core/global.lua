local global = {}
local os_name = vim.loop.os_uname().sysname

local FORMATTER = {
	"prettierd",
	"eslint_d",
	"stylua",
	-- go
	"goimports",
	"gofumpt",
	"rustfmt",
}
local LINTER = {
	"eslint_d",
	"luacheck",
	"revive",
	"jsonlint",
	-- go
	"staticcheck",
}
local CODE_ACTION = {
	-- go
	"gomodifytags",
}
local LSP = {
	"lua-language-server",
	"typescript-language-server",
	-- go
	"gopls",
	"rust-analyzer",
}
local ENABLE_COC = false

function global:load_variables()
	self.is_mac = os_name == "Darwin"
	self.is_linux = os_name == "Linux"
	self.is_windows = os_name == "Windows_NT"
	self.is_wsl = vim.fn.has("wsl") == 1
	self.vim_path = vim.fn.stdpath("config")
	local path_sep = self.is_windows and "\\" or "/"
	local home = self.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")
	self.cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
	self.modules_dir = self.vim_path .. path_sep .. "modules"
	self.home = home
	self.data_dir = string.format("%s/site/", vim.fn.stdpath("data"))
	self.fotmatter = FORMATTER
	self.linter = LINTER
	self.code_action = CODE_ACTION
	self.lsp = LSP
	self.enable_coc = ENABLE_COC
end

global:load_variables()

return global
