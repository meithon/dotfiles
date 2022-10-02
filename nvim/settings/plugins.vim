packadd vim-jetpack
call jetpack#begin('~/.vim/plugged')

" lua easymotion
Jetpack 'phaazon/hop.nvim'

" Like a easymotion in search
Jetpack 'hrsh7th/vim-searchx'

" More useful wildmenu
Jetpack 'gelguy/wilder.nvim'
  Jetpack 'romgrk/fzy-lua-native', {'do': 'make'}

Jetpack 'dstein64/vim-startuptime'

" Check my keybind
Jetpack 'folke/which-key.nvim'
Jetpack 'max397574/better-escape.nvim'

Jetpack 'lukas-reineke/indent-blankline.nvim'

Jetpack 'p00f/nvim-ts-rainbow'

" Startup screen
Jetpack 'mhinz/vim-startify', {'branch': 'center'} " require vim-devicons
Jetpack 'ryanoasis/vim-devicons'

Jetpack 'lukas-reineke/lsp-format.nvim'

" lsp
Jetpack 'neovim/nvim-lspconfig'
Jetpack 'williamboman/mason.nvim'
Jetpack 'williamboman/mason-lspconfig.nvim'
Jetpack 'ray-x/lsp_signature.nvim'

" auto complete
Jetpack 'hrsh7th/nvim-cmp'
Jetpack 'hrsh7th/cmp-nvim-lsp'
Jetpack 'hrsh7th/cmp-buffer'
Jetpack 'hrsh7th/cmp-path'
Jetpack 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Jetpack 'onsails/lspkind-nvim'
Jetpack 'ray-x/cmp-treesitter'
Jetpack 'f3fora/cmp-spell'
Jetpack 'saadparwaiz1/cmp_luasnip'
Jetpack 'L3MON4D3/LuaSnip', {'tag': 'v1.0.0'}
Jetpack 'rafamadriz/friendly-snippets' " 大量のスニペット郡

" Docker tool
Jetpack 'kkvh/vim-docker-tools'

" Translater
Jetpack 'skanehira/translate.vim'

" Syntax highlight
Jetpack 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Jetpack 'thinca/vim-qfreplace'

Jetpack 'tpope/vim-surround'

Jetpack 'tversteeg/registers.nvim', { 'branch': 'main' }

Jetpack 'mbbill/undotree'

Jetpack 'nvim-lualine/lualine.nvim'

Jetpack 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
"Jetpack 'BourgeoisBear/clrzr'

Jetpack 'nvim-colortils/colortils.nvim'
" CSS color picker
Jetpack 'ziontee113/color-picker.nvim'

" Multi cursor
Jetpack 'mg979/vim-visual-multi', {'branch': 'master'}

" Log browser
Jetpack 'junegunn/gv.vim'

Jetpack 'tpope/vim-fugitive'

" Git Diff
Jetpack 'lewis6991/gitsigns.nvim'

" Comment and uncomment lines
Jetpack 'numToStr/Comment.nvim'
Jetpack 'JoosepAlviste/nvim-ts-context-commentstring'

" A light and configurable statusline/tabline plugin for Vim
Jetpack 'itchyny/lightline.vim'

" Visualize undo history tree (in vim undo is not linear)
Jetpack 'mbbill/undotree'

" Syntax highlighting for languages
Jetpack 'sheerun/vim-polyglot'

" Fzf is a general-purpose command-line fuzzy finder
Jetpack 'ibhagwan/fzf-lua'
Jetpack 'kyazdani42/nvim-web-devicons'

" Python code formatter
Jetpack 'ambv/black'

" Color theme
Jetpack 'lifepillar/vim-gruvbox8'

" Automatically closes brackets
Jetpack 'jiangmiao/auto-pairs'

" Filer
Jetpack 'obaland/vfiler.vim'
Jetpack 'obaland/vfiler-column-devicons'
Jetpack 'obaland/vfiler-fzf'

call jetpack#end()
