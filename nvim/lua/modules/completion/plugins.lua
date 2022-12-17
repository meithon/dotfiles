local completion = {}
local conf = require("modules.completion.config")

local function i(p)
  p.event = { "InsertEnter" }
  return p
end

completion["jose-elias-alvarez/null-ls.nvim"] = {
  config = conf.null_ls,
	requires = { 
    { "nvim-lua/plenary.nvim" },
  },
}

completion["williamboman/mason.nvim"] = {
  config = conf.mason
}
completion["WhoIsSethDaniel/mason-tool-installer.nvim"] = {
  config = conf.mason_tool_installer
}

completion["williamboman/mason-lspconfig.nvim"] = {
  event = {"BufReadPre"},
  config = conf.mason_lspconfig,
    -- {"ray-x/lsp_signature.nvim", module = {'lsp_signature'}}
}
completion["hrsh7th/nvim-cmp"] = {
  config = conf.cmp,
  event = "InsertEnter",
  module = {"cmp"},
	requires = {
		i { "onsails/lspkind.nvim" , module= {"lspkind"}},
	  i { "lukas-reineke/cmp-under-comparator" },
		i { "saadparwaiz1/cmp_luasnip"},
    { "L3MON4D3/LuaSnip" },
		i	{ "hrsh7th/cmp-nvim-lsp", module = {"cmp_nvim_lsp"} },
		i	{ "hrsh7th/cmp-nvim-lua" },
		i	{ "andersevenrud/cmp-tmux" },
		i	{ "hrsh7th/cmp-path" },
		i	{ "f3fora/cmp-spell"},
		i	{ "hrsh7th/cmp-buffer"},
		i	{ "kdheepak/cmp-latex-symbols"},
		i	{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
		  config = conf.tabnine,
		},
  }
}
return completion
