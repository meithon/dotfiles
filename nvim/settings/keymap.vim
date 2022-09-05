" Map escape to jj
imap jj <Esc>

" Set mapleader to space
let mapleader = " "
" Maps
nmap <leader>hk :vsplit ~/dotfiles/nvim/hotkeys.md<cr>
nmap <leader>e :Fern . -reveal=% -drawer -toggle -width=40<cr>
" Git
nmap <leader>gg :Git<cr>
nmap <leader>gl :GV<cr>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>ga :Gwrite<cr>
nmap <leader>gc :Git commit<cr>
" Color picker
nnoremap <leader>cp :Colortils picker<cr>
nnoremap <leader>cg :Colortils gradient<cr>
nnoremap <leader>cl :Colortils lighten<cr>
nnoremap <leader>cd :Colortils darken<cr>

nmap <leader>cd <Plug>(coc-definition)
nmap <leader>cr <Plug>(coc-references.md)
nmap <leader><leader>p :Prettier<cr>
nmap <leader><leader>g :GoFmt<cr>
nmap <leader><leader>b :Black<cr>
nmap <leader><leader>u :UndotreeShow<cr>:UndotreeFocus<cr>
" Files (runs $FZF_DEFAULT_COMMAND if defined)
nmap <leader><leader>f :Files<cr>
nmap <leader><leader><leader>g :GoMetaLinter<cr>

nnoremap <leader>p :Telescope git_files<CR>
nnoremap <leader><leader>c :call NERDComment(0,"toggle")<CR>
vnoremap <leader><leader>c :call NERDComment(0,"toggle")<CR>
nnoremap <leader><Tab> :bnext<CR>
nnoremap <leader><S-Tab> :bprevious<CR>

nnoremap x "_x
nnoremap s "_S

nnoremap gl $
nnoremap gh ^
nnoremap gk H
nnoremap gj L

nnoremap <C-h> :%s//gI<Left><Left><Left>
nnoremap <leader>F :vimgrep // `git ls-files`<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

vmap gl $
vmap gh ^
vmap gk H
vmap gj L
vmap <leader>j <ESC>
