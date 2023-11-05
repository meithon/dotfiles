-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
local map = vim.keymap.set
return {
  { -- auto 改行
    "hrsh7th/nvim-insx",
    config = function()
      -- require("insx.preset.standard").setup()
      -- local insx = require("insx")
      -- Simple pair deletion recipe.
      -- require("insx").add(
      --   "(",
      --   require("insx.recipe.auto_pair")({
      --     open = "(",
      --     close = ")",
      --   })
      -- )
      -- require("insx").add(
      --   "(",
      --   require("insx.recipe.auto_pair").strings({
      --     open = [[']],
      --     close = [[']],
      --   })
      -- ) -- preset for strings.

      local esc = require("insx").helper.regex.esc
      require("insx").add(
        "<CR>",
        require("insx.recipe.fast_break")({
          open_pat = esc("("),
          close_pat = esc(")"),
          arguments = true,
          html_attrs = true,
        })
      )
      -- Simple pair deletion recipe.
      --
    end,
    event = "InsertEnter",
  },

  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
  },
  { -- bracket highlight
    "utilyre/sentiment.nvim",
    version = "*",
    event = "InsertEnter", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  { -- jump to bracker in insert mode
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
    dependencies = { "nvim-treesitter", "nvim-cmp" }, -- or require if not used so far
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6", --recomended as each new version will have breaking changes
    opts = {

      fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
        -- enable=true,
        -- enable_normal=true,
        -- enable_reverse=true,
        -- hopout=false,
        --{(|)} > fastwarp > {(}|)
        map = "<C-x>", --string or table
        -- rmap='<A-E>', --string or table
        -- cmap='<A-e>', --string or table
        -- rcmap='<A-E>', --string or table
      },
      --Config goes here
    },
  },
  {
    "echasnovski/mini.pairs",
    eneabled = false,
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      backdrop = 0.85, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      width = 340, -- width of the Zen window
      -- height = 0.95, -- height of the Zen window
    },
    config = true,
    cmd = "ZenMode",
  },
  -- {
  --   "sindrets/winshift.nvim",
  --   cmd = "WinShift",
  --   config = function()
  --     require("winshift").setup()
  --   end,
  -- },
  -- {
  --   "anuvyklack/windows.nvim",
  --   dependencies = "anuvyklack/middleclass",
  --   config = function()
  --     require("windows").setup()
  --   end,
  -- },
  -- {
  --   "nvim-focus/focus.nvim",
  --   version = "*",
  --   config = function()
  --     require("focus").setup({
  --       autoresize = {
  --         -- enable = true, -- Enable or disable auto-resizing of splits
  --         -- width = 20, -- Force width for the focused window
  --         -- height = 0, -- Force height for the focused window
  --         -- minwidth = 50, -- Force minimum width for the unfocused window
  --         -- minheight = 0, -- Force minimum height for the unfocused window
  --         -- height_quickfix = 10, -- Set the height of quickfix panel
  --       },
  --     })
  --
  --     -- local ignore_filetypes = { "neo-tree" }
  --     local ignore_filetypes = { "neo-tree" }
  --     local ignore_buftypes = { "nofile", "prompt", "popup" }
  --
  --     local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
  --
  --     -- vim.api.nvim_create_autocmd("WinEnter", {
  --     --   group = augroup,
  --     --   callback = function(_)
  --     --     if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
  --     --       vim.w.focus_disable = true
  --     --     else
  --     --       vim.w.focus_disable = false
  --     --     end
  --     --   end,
  --     --   desc = "Disable focus autoresize for BufType",
  --     -- })
  --
  --     vim.api.nvim_create_autocmd("FileType", {
  --       group = augroup,
  --       callback = function(_)
  --         if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
  --           vim.b.focus_disable = true
  --         else
  --           vim.b.focus_disable = false
  --         end
  --       end,
  --       desc = "Disable focus autoresize for FileType",
  --     })
  --   end,
  -- },
  -- Resize Window
  -- {
  --   "camspiers/lens.vim",
  --   config = function()
  --     vim.cmd([[ let g:lens#animate = 0 ]])
  --   end,
  -- },
  -- change completion settiongs
  {
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
  -- AI Plugins
  {
    "Bryley/neoai.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    config = function()
      require("neoai").setup({
        -- Options go here
      })
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  -- search word from git commits
  {
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      -- optional: setup telescope before loading the extension
      require("telescope").setup({
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {

            {
              -- fugitive or diffview
              diff_plugin = "fugitive",
              -- customize git in previewer
              -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
              git_flags = {},
              -- customize git diff in previewer
              -- e.g. flags such as { "--raw" }
              git_diff_flags = {},
              -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
              show_builtin_git_pickers = false,
              entry_default_author_or_date = "author", -- one of "author" or "date"

              -- Telescope layout setup
              telescope_theme = {
                function_name_1 = {
                  -- Theme options
                },
                function_name_2 = "dropdown",
                -- e.g. realistic example
                show_custom_functions = {
                  layout_config = { width = 0.4, height = 0.4 },
                },
              },
            },

            -- See Config
            --
          },
        },
      })

      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
      -- to open commits in browser with fugitive
      "tpope/vim-rhubarb",
      -- optional: to replace the diff from fugitive with diffview.nvim
      -- (fugitive is still needed to open in browser)
      -- "sindrets/diffview.nvim",
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = false },
  },
  {
    "nvimdev/lspsaga.nvim",
    opt = {},
    config = function(_, opts)
      require("lspsaga").setup(opts)
      -- disabe default keymaps
      vim.keymap.set("n", "<leader>l", function() end) -- Open lazy
    end,
    cmd = "Lspsaga",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
      -- replace LazyVim command
      {
        "[e",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Go to previous error",
      },
      {
        "]e",
        function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Go to prev error",
      },
      {
        "[d",
        function()
          require("lspsaga.diagnostic"):goto_prev()
        end,
        desc = "Go to prev diagnostic",
      },
      {
        "]d",
        function()
          require("lspsaga.diagnostic"):goto_next()
        end,
        desc = "Go to next diagnostic",
      },
      {
        "<leader>l",
        desc = "Remap <leader>l",
      },
      {
        "<leader>ld",
        function()
          require("lspsaga.definition"):init(1, 1)
        end,
        desc = "Peek to definition (Lspsaga)",
      },
      {
        "<leader>ly",
        function()
          require("lspsaga.definition"):init(2, 1)
        end,
        desc = "Peek to t[y]pe definition (Lspsaga)",
      },
      {
        "<leader>lf",
        function()
          require("lspsaga.definition"):init(2, 1)
        end,
        desc = "Peek to t[y]pe definition (Lspsaga)",
      },
    },
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
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    opts = {},
    config = function(opts)
      require("neogit").setup(opts)
      map("n", "<space>gs", "<cmd>Neogit<cr>", { desc = "Open git tool interface" })
    end,
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Open git tool interface" },
    },
  },
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        extra_groups = { -- table/string: additional groups that should be cleared
          -- In particular, when you set it to 'all', that means all available groups

          -- example of akinsho/nvim-bufferline.lua
          "BufferLineTabClose",
          "BufferlineBufferSelected",
          "BufferLineFill",
          "BufferLineBackground",
          "BufferLineSeparator",
          "BufferLineIndicatorSelected",
        },
      })
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = { { "<C-n>", mode = { "v", "i", "n" } } },
    config = function() end,
    enabled = not vim.g.vscode,
  },
  {
    "chaoren/vim-wordmotion",
    keys = {
      { "w", mode = { "n", "v" } },
      { "e", mode = { "n", "v" } },
      { "b", mode = { "n", "v" } },
      { "W", mode = { "n", "v" } },
      { "E", mode = { "n", "v" } },
      { "B", mode = { "n", "v" } },
    },
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

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
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

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
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
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp-document-symbol" },
    config = function()
      local cmp = require("cmp")
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
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
        mapping = cmp.mapping.preset.cmdline(),
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
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys(t("<Down>"), "n", true)
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
        ["<C-p>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys(t("<Up>"), "n", true)
            end
          end,
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
