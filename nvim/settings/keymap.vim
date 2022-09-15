" Map escape to jj
imap jj <Esc>

" Set mapleader to space
let mapleader = " "
" Maps
nmap <leader>hk :vsplit ~/dotfiles/nvim/hotkeys.md<cr>
nmap <leader>e :VFiler -layout=floating<cr>
nmap <leader>t :Translate<cr>
vmap <leader>t :'<,'>Translate<cr>
nmap <leader>dt :DockerToolsOpen<cr>
" Git
nmap <leader>gg :Git<cr>
nmap <leader>gl :GV<cr>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>ga :Gwrite<cr>
nmap <leader>gc :Git commit<cr>
" Color picker
nnoremap <leader>cp :Colortils picker<cr>

nmap <leader>cd <Plug>(coc-definition)
nmap <leader>cr <Plug>(coc-references.md)
nmap <leader><leader>p :Prettier<cr>
nmap <leader><leader>u :UndotreeShow<cr>:UndotreeFocus<cr>
" Files (runs $FZF_DEFAULT_COMMAND if defined)
nmap <leader><leader>f :FzfLua files<cr>

nnoremap <leader>p :FzfLua git_files<CR>
nnoremap <leader><Tab> :FzfLua buffers<CR>

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

imap <c-f> <Right>
imap <c-b> <Left>
imap <c-n> <Down>
imap <c-p> <Up>
