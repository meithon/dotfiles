local ui = {}
local conf = require("modules.ui.config")

ui["lilydjwg/colorizer"] = {
	config = conf.colorizer,
}
ui["folke/tokyonight.nvim"] = {
	opt = false,
}
ui["folke/zen-mode.nvim"] = {
	opt = false,
}
ui["folke/noice.nvim"] = {
	requires = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = conf.noice,
}
ui["gelguy/wilder.nvim"] = {
	requires = { "romgrk/fzy-lua-native", run = "make" },
	config = conf.wilder,
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	opt = false,
	config = conf.indent_blankline,
}
ui["mhinz/vim-startify"] = {
	opt = false,
	config = conf.startify,
	branch = "center",
}
ui["ryanoasis/vim-devicons"] = {}
ui["nvim-treesitter/nvim-treesitter"] = {
	config = conf.treesitter,
	module = { "nvim-treesitter" },
	requires = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "theHamsta/tree-sitter-html" },
		{ "David-Kunz/markid" },
		{ "windwp/nvim-ts-autotag" },
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "p00f/nvim-ts-rainbow" },
		{ "andymass/vim-matchup" },
	},
}
ui["nvim-lualine/lualine.nvim"] = {
	config = conf.lualine,
}
-- ui["akinsho/nvim-bufferline.lua"] = {
-- 	config = conf.bufferline,
-- }
ui["kdheepak/tabline.nvim"] = {
	config = conf.tabline,
	want = { "nvim-lualine/lualine.nvim" },
}

return ui
