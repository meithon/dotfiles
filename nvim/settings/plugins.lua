local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

return packer.startup(function(use)
  use 'mattn/emmet-vim'

  -- Improve startup time
  use 'lewis6991/impatient.nvim'

  use 'matze/vim-move'

  -- Text alignmenter
  use 'junegunn/vim-easy-align'

  -- lua easymotion
  use 'ggandor/lightspeed.nvim'

  -- more powerful wordmotion
  use 'chaoren/vim-wordmotion'

  -- Like a easymotion in search
  use 'hrsh7th/vim-searchx'

  -- More useful wildmenu
  use { 'gelguy/wilder.nvim',
    requires = {'romgrk/fzy-lua-native', run = 'make' }
  }

  use 'dstein64/vim-startuptime'

  -- Check my keybind
  use 'folke/which-key.nvim'
  use 'max397574/better-escape.nvim'

  use 'lukas-reineke/indent-blankline.nvim'

  use 'p00f/nvim-ts-rainbow'

  -- Startup screen
  use {'mhinz/vim-startify', branch = 'center'} -- require vim-devicons
  use 'ryanoasis/vim-devicons'

  -- Formatter and linter
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {{ 'nvim-lua/plenary.nvim' }, { 'jayp0521/mason-null-ls.nvim' }}
  }

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'ray-x/lsp_signature.nvim'
  use 'glepnir/lspsaga.nvim'

  -- auto complete
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use { 'tzachar/cmp-tabnine',  run = './install.sh' }
  use 'onsails/lspkind-nvim'
  use 'ray-x/cmp-treesitter'
  use 'f3fora/cmp-spell'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets' -- 大量のスニペット郡

  -- Docker tool
  use 'kkvh/vim-docker-tools'

  -- Translater
  use 'skanehira/translate.vim'

  -- Syntax highlight
  use { 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate'}
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'theHamsta/tree-sitter-html'
  use 'David-Kunz/markid'

  -- auto close html tag
  use 'windwp/nvim-ts-autotag'

  use 'thinca/vim-qfreplace'

  use 'tpope/vim-surround'

  use {  'tversteeg/registers.nvim',  branch = 'main' }

  use 'nvim-lualine/lualine.nvim'
  use 'akinsho/nvim-bufferline.lua'
  -- use'romgrk/barbar.nvim'

  -- color picke . require nvim 8.0
  use 'uga-rosa/ccc.nvim'

  -- color display
  use 'NvChad/nvim-colorizer.lua'


  -- Multi cursor
  use { 'mg979/vim-visual-multi', branch = 'master'}

  -- Log browser
  use 'junegunn/gv.vim'

  use 'tpope/vim-fugitive'

  -- Git Diff
  use 'lewis6991/gitsigns.nvim'

  -- Comment and uncomment lines
  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- Visualize undo history tree (in vim undo is not linear)
  use 'mbbill/undotree'

  -- Syntax highlighting for languages
  use 'sheerun/vim-polyglot'

  -- Fzf is a general-purpose command-line fuzzy finder
  use 'ibhagwan/fzf-lua'
  use 'kyazdani42/nvim-web-devicons'

  -- Color theme
  use 'lifepillar/vim-gruvbox8'

  -- Automatically closes brackets
  use 'jiangmiao/auto-pairs'

  -- Filer
  use 'obaland/vfiler.vim'
  use 'obaland/vfiler-column-devicons'
  use 'obaland/vfiler-fzf'
end)
