function! s:start_exprolorer() abort
" エクスプローラースタイルで起動する
" ※起動時に指定したオプションはデフォルトオプションよりも優先されて起動する
lua <<EOF

local configs = {
  options = {
    show_hidden_files = true,
    auto_cd = true,
    auto_resize = true,
    keep = true,
    name = 'exp',
    layout = 'left',
    width = 36,
    columns = 'indent,devicons,name,git',
    git = {
      enabled = true,
      untracked = true,
      ignored = true,
    },
  },
}

-- 現在開いているファイルのディレクトリを取得する
local path = vim.fn.bufname(vim.fn.bufnr())
if vim.fn.isdirectory(path) ~= 1 then
  path = vim.fn.getcwd()
end
path = vim.fn.fnamemodify(path, ':p:h')

-- Lua 関数による起動
require'vfiler'.start(path, configs)

EOF
endfunction

" エクスプローラースタイルで起動 (関数による起動)
noremap <silent><Leader>e :call <SID>start_exprolorer()<CR>

" フローティングスタイルで起動 (VFiler コマンドからオプション指定で起動)
" ※フローティングスタイルの指定以外は、デフォルトオプション値で起動する
noremap <silent><Leader>E <Cmd>VFiler -layout=floating<CR>
