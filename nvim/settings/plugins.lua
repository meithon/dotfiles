local status, packer = pcall(require, "packer")
if not status then
	vim.notify("Packer is not installed", "error")
	return
end

vim.cmd([[packadd packer.nvim]])

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	use("bayne/vim-dot-http")

	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({})
		end,
	})

	use({
		"folke/noice.nvim",
		requires = {
			{ "MunifTanjim/nui.nvim" },
			{ "rcarriga/nvim-notify" },
		},
	})

	-- floating terminal
	use("numToStr/FTerm.nvim")

	-- useful number searcher
	use("nacro90/numb.nvim")

	use("mattn/emmet-vim")

	-- Improve startup time
	use("lewis6991/impatient.nvim")

	use("matze/vim-move")

	-- Text alignmenter
	use("junegunn/vim-easy-align")

	-- lua easymotion
	use("ggandor/lightspeed.nvim")

	-- more powerful wordmotion
	use("chaoren/vim-wordmotion")

	-- Like a easymotion in search
	use("hrsh7th/vim-searchx")

	-- More useful wildmenu
	use({ "gelguy/wilder.nvim", requires = { "romgrk/fzy-lua-native", run = "make" } })

	use("dstein64/vim-startuptime")

	-- Check my keybind
	use("folke/which-key.nvim")
	use("max397574/better-escape.nvim")

	use("lukas-reineke/indent-blankline.nvim")

	use("p00f/nvim-ts-rainbow")

	-- Startup screen
	use({ "mhinz/vim-startify", branch = "center" }) -- require vim-devicons
	use("ryanoasis/vim-devicons")

	-- Formatter and linter
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "jayp0521/mason-null-ls.nvim" } },
	})

	-- lsp
	use("neovim/nvim-lspconfig")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("ray-x/lsp_signature.nvim")
	use("glepnir/lspsaga.nvim")

	-- auto complete
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use({ "tzachar/cmp-tabnine", run = "./install.sh" })
	use("onsails/lspkind-nvim")
	use("ray-x/cmp-treesitter")
	use("f3fora/cmp-spell")
	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets") -- 大量のスニペット郡

	-- Docker tool
	use("kkvh/vim-docker-tools")

	-- Translater
	use("skanehira/translate.vim")

	-- Syntax highlight
	use({ "nvim-treesitter/nvim-treesitter", run = "TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("theHamsta/tree-sitter-html")
	use("David-Kunz/markid")

	-- auto close html tag
	use("windwp/nvim-ts-autotag")

	-- for vimgrep and quickfix
	use("thinca/vim-qfreplace")
	-- foratwindow for quickfix
	use({ "kevinhwang91/nvim-bqf", ft = "qf" })

	use("tpope/vim-surround")

	use({ "tversteeg/registers.nvim", branch = "main" })

	use("nvim-lualine/lualine.nvim")
	use("akinsho/nvim-bufferline.lua")
	-- use'romgrk/barbar.nvim'

	-- color picke . require nvim 8.0
	use("uga-rosa/ccc.nvim")

	-- color display
	use("NvChad/nvim-colorizer.lua")

	-- Multi cursor
	use({ "mg979/vim-visual-multi", branch = "master" })

	-- Log browser
	use("junegunn/gv.vim")

	use("tpope/vim-fugitive")

	-- Git Diff
	use("lewis6991/gitsigns.nvim")

	-- Comment and uncomment lines
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Visualize undo history tree (in vim undo is not linear)
	use("mbbill/undotree")

	-- Syntax highlighting for languages
	use("sheerun/vim-polyglot")

	-- Fzf is a general-purpose command-line fuzzy finder
	use("ibhagwan/fzf-lua")
	use("kyazdani42/nvim-web-devicons")
	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})

	use({
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "kkharji/sqlite.lua", module = "sqlite" },
			-- you'll need at least one of these
			{ "nvim-telescope/telescope.nvim" },
			-- {'ibhagwan/fzf-lua'},
		},
	})

	-- Color theme
	use("lifepillar/vim-gruvbox8")
	use({
		"folke/tokyonight.nvim",
		config = { vim.cmd([[colorscheme tokyonight-moon]]) },
	})

	-- Automatically closes brackets
	use("windwp/nvim-autopairs")

	-- Filer
	use("obaland/vfiler.vim")
	use("obaland/vfiler-column-devicons")
	use("obaland/vfiler-fzf")
end)
