local global = require("core.global")

-- if vscode , then disable lsp
if vim.g.vscode then
  return
end

if not global.enable_coc then
  return require("modules.lsp.nvim-lsp")
else
  return require("modules.lsp.coc")
end

return
