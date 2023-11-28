-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
--
-- * override the configuration of LazyVim plugins
local map = vim.keymap.set
return {
  { -- add window picker to neo-tree
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            highlights = {
              statusline = {
                focused = {
                  fg = "#ededed",
                  bg = "#e35e4f",
                  bold = true,
                },
                unfocused = {
                  fg = "#ededed",
                  bg = "#44cc41",
                  bold = true,
                },
              },
              winbar = {
                focused = {
                  fg = "#ededed",
                  bg = "#e35e4f",
                  bold = true,
                },
                unfocused = {
                  fg = "#ededed",
                  bg = "#44cc41",
                  bold = true,
                },
              },
            },
          })
        end,
      },
    },
  },

  { --
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      for i, item in ipairs(opts) do
        if item == null_ls.builtins.diagnostics.eslint then
          opts[i] = null_ls.builtins.diagnostics.eslint.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity.WARN
            end,
          })
          break
        end
      end
      -- table.insert(
      --   opts.sources,
      --   null_ls.builtins.diagnostics.eslint.with({
      --     diagnostics_postprocess = function(diagnostic)
      --       diagnostic.severity = vim.diagnostic.severity.WARN
      --     end,
      --   })
      -- )
    end,
  },
  { -- better typescript error
    "neovim/nvim-lspconfig",
    dependencies = "davidosomething/format-ts-errors.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = function(_, opts)
      opts.servers.tsserver.handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          if result.diagnostics == nil then
            return
          end

          -- ignore some tsserver diagnostics
          local idx = 1
          while idx <= #result.diagnostics do
            local entry = result.diagnostics[idx]

            local formatter = require("format-ts-errors")[entry.code]
            entry.message = formatter and formatter(entry.message) or entry.message

            -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            if entry.code == 80001 then
              -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
              table.remove(result.diagnostics, idx)
            else
              idx = idx + 1
            end
          end

          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "poljar/typos.nvim",
    },
    opts = function(_, opts)
      local typos = require("typos")
      typos.setup()
      table.insert(opts.sources, typos.actions)
    end,
  },
  { -- change completion settings
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },

    opts = function(_, opts)
      local compare = require("cmp.config.compare")

      opts.sorting = {
        priority_weight = 2,
        comparators = {
          require("copilot_cmp.comparators").prioritize,
          compare.offset,
          compare.exact,
          compare.score,
          compare.length,
          -- require("cmp_tabnine.compare"),
          compare.recently_used,
          compare.kind,
          compare.sort_text,
          compare.order,
        },
      }
    end,
    -- opts = function()
    --   local cmp = require("cmp")
    --   local defaults = require("cmp.config.default")()
    --   return {
    --       sorting = defaults.sorting,
    --   }
    -- end,
    -- ---@param opts cmp.ConfigSchema
    -- config = function(_, opts)
    --   for _, source in ipairs(opts.sources) do
    --     source.group_index = source.group_index or 1
    --   end
    --   require("cmp").setup(opts)
    -- end,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
        },
      })
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      { "vi", "<cmd>STSSelectCurrentNode<cr>", mode = "n", desc = "Select Current Node" },
      { "va", "<cmd>STSSelectMasterNode<cr>", mode = "n", desc = "Select Master Node" },
      { "N", "<cmd>STSSelectNextSiblingNode<cr>", mode = "x", desc = "Select Next Sibling Node" },
      { "P", "<cmd>STSSelectPrevSiblingNode<cr>", mode = "x", desc = "Select Previous Sibling Node" },
      { "K", "<cmd>STSSelectParentNode<cr>", mode = "x", desc = "Select Parent Node" },
      { "J", "<cmd>STSSelectChildNode<cr>", mode = "x", desc = "Select Child Node" },
    },
    config = function()
      require("syntax-tree-surfer").setup()
    end,
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer(true)
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner(true, "V")
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },
  -- Disable code context
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
  },
  -- Disable indent line
  {
    "echasnovski/mini.indentscope",
    enabled = false,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      -- table.insert(opts.options, { show_close_icon = false })

      -- opts.options.show_close_icon = false
      opts.options = vim.tbl_extend("force", opts.options, {
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "underline",
        },
      })
    end,
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Find Git File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  { -- setup cmp-cmdline
    "hrsh7th/cmp-cmdline",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    config = function()
      local cmp = require("cmp")
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping({
            c = function()
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            end,
          }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      require("cmp").setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping({
            c = function()
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            end,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-e>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            -- vim.api.nvim_replace_termcodes("<Plug>(TaboutBack)", true, true, true)
            fallback()
          end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
          -- c = function()
          --   if cmp.visible() then
          --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          --   else
          --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
          --   end
          -- end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
        ["<C-p>"] = cmp.mapping({
          -- c = function()
          --   if cmp.visible() then
          --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          --   else
          --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
          --   end
          -- end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
      })
    end,
  },
}
