local status, mason = pcall(require, "mason")
if (not status) then return end
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("lsp-format").setup{}

local status, lspconfig = pcall(require, "mason-lspconfig")
if (not status) then return end
lspconfig.setup_handlers({
  function(server) -- default handler (optional)
    local opt = {
      -- -- Function executed when the LSP server startup
      -- on_attach = function(client, bufnr)
      --   local opts = { noremap=true, silent=true }
      --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
      -- end,
      capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      ),
      on_attach = require("lsp-format").on_attach
    }
    require('lspconfig')[server].setup(opt)
  end
})
