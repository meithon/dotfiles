lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

        -- For `luasnip` user.
        -- require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      -- ['<C-i>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.abort()
        else
          cmp.complete()
        end
      end),
      ['<Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if cmp.visible() then
          cmp.select_next_item()
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if cmp.visible() then
          cmp.select_prev_item()
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end),
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      -- { name = 'vsnip' },

      -- For luasnip user.
      -- { name = 'luasnip' },

      -- For ultisnips user.
      -- { name = 'ultisnips' },

      { name = 'cmp_tabnine' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'treesitter' },
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = false, -- do not show text alongside icons
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function (entry, vim_item)
          return vim_item
        end
      })
    }
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

EOF
