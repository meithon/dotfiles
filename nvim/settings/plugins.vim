call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" Git Diff
Plug 'airblade/vim-gitgutter'

" Make your Vim/Neovim as smart as VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Formatter
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Comment and uncomment lines
Plug 'preservim/nerdcommenter'

" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'

" Visualize undo history tree (in vim undo is not linear)
Plug 'mbbill/undotree'

" Syntax highlighting for languages
Plug 'sheerun/vim-polyglot'

" Fzf is a general-purpose command-line fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" This plugin adds Go language support for Vim, with many features
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Python code formatter
Plug 'ambv/black'

" Gruvbox color theme
Plug 'morhetz/gruvbox'

" Vim-monokai-tasty color theme
Plug 'patstockwell/vim-monokai-tasty'

" Automatically closes brackets
Plug 'jiangmiao/auto-pairs'

" Filer
Plug 'lambdalisue/fern.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'

call plug#end()
