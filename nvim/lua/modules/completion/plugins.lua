local completion = {}
local conf = require("module.completion.config")

competion["jose-elias-alvarez/null-ls.nvim"] = {
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
competion["hrsh7th/nvim-cmp"] = {
	-- config = conf.cmp,
	event = "InsertEnter",
	requires = {
		{ "onsails/lspkind.nvim" },
		{ "lukas-reineke/cmp-under-comparator" },
		{ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
		{ "hrsh7th/cmp-nvim-lsp", after = "cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
		{ "andersevenrud/cmp-tmux", after = "cmp-nvim-lua" },
		{ "hrsh7th/cmp-path", after = "cmp-tmux" },
		{ "f3fora/cmp-spell", after = "cmp-path" },
		{ "hrsh7th/cmp-buffer", after = "cmp-spell" },
		{ "kdheepak/cmp-latex-symbols", after = "cmp-buffer" },
		{
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			after = "cmp-latex-symbols",
			-- config = conf.tabnine,
		},
	},
}
competion["L3MON4D3/LuaSnip"] = {
	opt = true,
}
competion["rafamadriz/friendly-snippets"] = {
	opt = true,
}


return completion
