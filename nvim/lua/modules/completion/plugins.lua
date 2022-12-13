local completion = {}
local conf = require("modules.completion.config")

local function i(p)
  p.event = { "InsertEnter" }
  return p
end

completion["jose-elias-alvarez/null-ls.nvim"] = {
	opt = true,
	requires = { { "nvim-lua/plenary.nvim" }, { "jayp0521/mason-null-ls.nvim" } },
}
competion["neovim/nvim-lspconfig"] = {
	opt = true,
}
competion["williamboman/mason.nvim"] = {
	opt = true,
}
competion["williamboman/mason-lspconfig.nvim"] = {
	opt = true,
}
completion["hrsh7th/nvim-cmp"] = {
  config = conf.cmp,
	event = "InsertEnter",
  module = {"cmp"},
	requires = {
		i { "onsails/lspkind.nvim" , module= {"lspkind"}},
	 	i { "lukas-reineke/cmp-under-comparator" },
		i	{ "saadparwaiz1/cmp_luasnip",  
      requires = {
        {"L3MON4D3/LuaSnip"}
      }
    },
		i	{ "hrsh7th/cmp-nvim-lsp" },
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
	},
}
completion["rafamadriz/friendly-snippets"] = {
	opt = true,
}


return completion
