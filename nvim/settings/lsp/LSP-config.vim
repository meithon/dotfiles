lua << EOF

local nvim_lsp = require('lspconfig')
-- local servers = {
--   'gopls'
-- }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--     flags = {
--       debounce_text_changes = 150,
--     }
--   }
-- end

-- require'lspconfig'.volar.setup{}

EOF

" nnoremap <silent>gD <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent>gH <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent>gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent><space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
" nnoremap <silent><space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
" nnoremap <silent><space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
" nnoremap <silent><space>D <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent><space>rn <cmd>lua vim.lsp.buf.rename()<CR>
" nnoremap <silent><space>ca <cmd>lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent>gf <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent><space>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent>[d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent>]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <silent><space>q <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
" nnoremap <silent><space>f <cmd>lua vim.lsp.buf.formatting()<CR>
