" Set mapleader to space
let mapleader = " "
" Maps
nmap <leader>hk :vsplit ~/dotfiles/nvim/hotkeys.md<cr>
nmap <leader>e :VFiler -layout=floating<cr>
nmap <leader>tp :BufferLinePick<cr>
vmap <leader>tl :'<,'>Translate<cr>
nmap <leader>dt :DockerToolsOpen<cr>
nnoremap <leader>tsc :set spell!<CR>
" Git
nmap <leader>gs :Git<cr>
nmap <leader>gl :GV<cr>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>gc :Git commit<cr>
nmap <leader>ga :Gitsigns stage_hunk<cr>
vmap <leader>ga :Gitsigns stage_hunk<cr>
nmap <leader>gu :Gitsigns undo_stage_hunk<cr>
vmap <leader>gu :Gitsigns undo_stage_hunk<cr>
vmap <leader>gr :Gitsigns reset_hunk<cr>
nmap <leader>gtd :Gitsigns toggle_deleted<cr>:Gitsigns toggle_numhl<cr>
nmap gk :Gitsigns prev_hunk<cr> zz k
nmap gj :Gitsigns next_hunk<cr> zz

" Color picker
nnoremap <leader><cr> :CccPick<cr>

nmap <leader>cd <Plug>(coc-definition)
nmap <leader>cr <Plug>(coc-references.md)
nmap <leader><leader>u :UndotreeShow<cr>:UndotreeFocus<cr>
" Files (runs $FZF_DEFAULT_COMMAND if defined)
nmap <leader><leader>f :Telescope find_files<cr>

nnoremap <leader>p :Telescope git_files<CR>
nnoremap <leader><Tab> :Telescope buffers<CR>
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

nnoremap x "_x

nnoremap <C-h> :%s//gI<Left><Left><Left>
nnoremap <leader>F :vimgrep // `git ls-files`<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

nnoremap <CR> i<Return><Esc>^k

vmap gl $
vmap gh ^
vmap gk H
vmap gj L
vmap <leader>j <ESC>

imap <c-f> <Right>
imap <c-b> <Left>
imap <c-n> <Down>
imap <c-p> <Up>

tnoremap <ESC> <C-\><C-n>
tnoremap jk <C-\><C-n>
