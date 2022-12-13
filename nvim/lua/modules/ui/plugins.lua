local ui = {}
local conf = require("modules.ui.config")

ui["folke/tokyonight.nvim"] = {
	opt = false,
}
ui["folke/zen-mode.nvim"] = {
	opt = false,
}
ui["folke/noice.nvim"] = {
	opt = true,
	requires = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
ui["gelguy/wilder.nvim"] = {
	opt = true,
	requires = { "romgrk/fzy-lua-native", run = "make" },
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	opt = true,
}
ui["p00f/nvim-ts-rainbow"] = {
	opt = true,
}
ui["mhinz/vim-startify"] = {
	opt = true,
	branch = "center",
}
ui["ryanoasis/vim-devicons"] = {
	opt = true,
}
ui["ray-x/lsp_signature.nvim"] = {
	opt = true,
}
ui["nvim-treesitter/nvim-treesitter"] = {
	opt = true,
	run = "TSUpdate",
	want = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"theHamsta/tree-sitter-html",
		"David-Kunz/markid",
		"windwp/nvim-ts-autotag",
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
}
ui["nvim-lualine/lualine.nvim"] = {
	opt = true,
}
ui["akinsho/nvim-bufferline.lua"] = {
	opt = true,
}

return ui
