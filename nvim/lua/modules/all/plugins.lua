local all = {}
local conf = require("modules.all.config")

-- completion
all["jose-elias-alvarez/null-ls.nvim"] = {
	opt = true,
	requires = { { "nvim-lua/plenary.nvim" }, { "jayp0521/mason-null-ls.nvim" } },
}
all["neovim/nvim-lspconfig"] = {
	opt = true,
}
all["williamboman/mason.nvim"] = {
	opt = true,
}
all["williamboman/mason-lspconfig.nvim"] = {
	opt = true,
}
all["hrsh7th/nvim-cmp"] = {
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
all["L3MON4D3/LuaSnip"] = {
	opt = true,
}
all["rafamadriz/friendly-snippets"] = {
	opt = true,
}

-- editor
all["nacro90/numb.nvim"] = {
	opt = true,
}
all["mattn/emmet-vim"] = {
	opt = true,
}
all["matze/vim-move"] = {
	opt = true,
}
all["junegunn/vim-easy-align"] = {
	opt = true,
}
all["ggandor/lightspeed.nvim"] = {
	opt = true,
}
all["chaoren/vim-wordmotion"] = {
	opt = true,
}
all["hrsh7th/vim-searchx"] = {
	opt = true,
}
all["max397574/better-escape.nvim"] = {
	opt = true,
}
all["tpope/vim-surround"] = {
	opt = true,
}
all["tversteeg/registers.nvim"] = {
	opt = true,
	branch = "main",
}
all["NvChad/nvim-colorizer.lua"] = {
	opt = true,
}
all["mg979/vim-visual-multi"] = {
	opt = true,
	branch = "master",
}

-- tool
all["bayne/vim-dot-http"] = {
	opt = true,
}
all["chipsenkbeil/distant.nvim"] = {
	opt = false,
}
all["numToStr/FTerm.nvim"] = {
	opt = true,
}
all["lewis6991/impatient.nvim"] = {
	opt = true,
}
all["dstein64/vim-startuptime"] = {
	opt = true,
}
all["folke/which-key.nvim"] = {
	opt = true,
}
all["glepnir/lspsaga.nvim"] = {
	opt = true,
}
all["kkvh/vim-docker-tools"] = {
	opt = true,
}
all["skanehira/translate.vim"] = {
	opt = true,
}
all["thinca/vim-qfreplace"] = {
	opt = true,
}
all["kevinhwang91/nvim-bqf"] = {
	opt = true,
	ft = "qf",
}
all["uga-rosa/ccc.nvim"] = {
	opt = true,
}
all["tpope/vim-fugitive"] = {
	opt = true,
  cmd = {"Git", "Gdiffsplit", "Gvdiffsplit"},
  require = {{"junegunn/gv.vim", opt = true, cmd = "GV"}}
}
all["lewis6991/gitsigns.nvim"] = {
	opt = true,
  event = {"FocusLost", "CursorHold", "BufRead"},
  cmd = "Gitsigns",
  config = conf.gitsigns
}
all["mbbill/undotree"] = {
	opt = true,
  cmd = {"UndotreeShow", "UndotreeFocus"}
}
all["nvim-telescope/telescope.nvim"] = {
	opt = true,
	module = "telescope",
	cmd = "Telescope",
	requires = {
		{ "nvim-lua/plenary.nvim", opt = false },
		{ "nvim-lua/popup.nvim", opt = true },
	},
}
all["nvim-lua/plenary.nvim"] = {
	opt = false,
}
all["nvim-lua/popup.nvim"] = {
	opt = true,
}
all["nvim-lua/popup.nvim"] = {
	opt = true,
}
all["obaland/vfiler.vim"] = {
	opt = true,
  cmd = "VFiler"
}
all["obaland/vfiler-column-devicons"] = {
	opt = true,
}

-- ui
all["folke/tokyonight.nvim"] = {
	opt = false,
}
all["folke/zen-mode.nvim"] = {
	opt = false,
}
all["folke/noice.nvim"] = {
	opt = true,
	requires = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
all["gelguy/wilder.nvim"] = {
	opt = true,
	requires = { "romgrk/fzy-lua-native", run = "make" },
}
all["lukas-reineke/indent-blankline.nvim"] = {
	opt = true,
}
all["p00f/nvim-ts-rainbow"] = {
	opt = true,
}
all["mhinz/vim-startify"] = {
	opt = true,
	branch = "center",
}
all["ryanoasis/vim-devicons"] = {
	opt = true,
}
all["ray-x/lsp_signature.nvim"] = {
	opt = true,
}
all["nvim-treesitter/nvim-treesitter"] = {
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
all["nvim-lualine/lualine.nvim"] = {
	opt = true,
}
all["akinsho/nvim-bufferline.lua"] = {
	opt = true,
}

return all
