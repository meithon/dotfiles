lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  local luasnip = require('luasnip')

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

        -- For `luasnip` user.
        require('luasnip').lsp_expand(args.body)

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
      ['<Down>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          fallback()
        else
          cmp.complete()
        end
      end),
      ['<UP>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif has_words_before() then
          fallback()
        else
          cmp.complete()
        end
      end),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
                select = true
          })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
        end, {"i", "s"}),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'spell' },

      -- For vsnip user.
      -- { name = 'vsnip' },

      -- For luasnip user.
      { name = 'luasnip' },

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
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            vsnip = '[Snippet]',
            nvim_lua = '[Nvim Lua]',
            buffer = '[Buffer]',
            cmp_tabnine = '[TN]',
            spell = '[Spell]',
            luasnip ="[LuaSnip]",
          })[entry.source.name]

          vim_item.dup = ({
            vsnip = 0,
            nvim_lsp = 0,
            nvim_lua = 0,
            buffer = 0,
          })[entry.source.name] or 0
          return vim_item
        end
      })
    }
  })
EOF
