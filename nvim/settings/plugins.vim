call plug#begin('~/.vim/plugged')

Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'p00f/nvim-ts-rainbow'

" Startup screen
" Plug 'glepnir/dashboard-nvim'
" Plug 'goolord/alpha-nvim'
Plug 'mhinz/vim-startify', {'branch': 'center'}
Plug 'ryanoasis/vim-devicons'

Plug 'lukas-reineke/lsp-format.nvim'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'ray-x/lsp_signature.nvim'

" auto complete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/cmp-treesitter'
Plug 'f3fora/cmp-spell'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v<CurrentMajor>.*'}
Plug 'rafamadriz/friendly-snippets' " 大量のスニペット郡

" Docker tool
Plug 'kkvh/vim-docker-tools'

" Translater
Plug 'skanehira/translate.vim'

" Syntax highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'thinca/vim-qfreplace'

Plug 'tpope/vim-surround'

Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

Plug 'mbbill/undotree'

Plug 'nvim-lualine/lualine.nvim'

Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
"Plug 'BourgeoisBear/clrzr'

Plug 'nvim-colortils/colortils.nvim'
" CSS color picker
Plug 'ziontee113/color-picker.nvim'

" Multi cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Log browser
Plug 'junegunn/gv.vim'

Plug 'tpope/vim-fugitive'

" Git Diff
Plug 'lewis6991/gitsigns.nvim'

" Comment and uncomment lines
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'

" Visualize undo history tree (in vim undo is not linear)
Plug 'mbbill/undotree'

" Syntax highlighting for languages
Plug 'sheerun/vim-polyglot'

" Fzf is a general-purpose command-line fuzzy finder
Plug 'ibhagwan/fzf-lua'
Plug 'kyazdani42/nvim-web-devicons'

" Python code formatter
Plug 'ambv/black'

" Color theme
Plug 'lifepillar/vim-gruvbox8'

" Automatically closes brackets
Plug 'jiangmiao/auto-pairs'

" Filer
Plug 'obaland/vfiler.vim'
Plug 'obaland/vfiler-column-devicons'
Plug 'obaland/vfiler-fzf'

call plug#end()
