local map = vim.keymap.set

---@alias Plugins plugins.Plugin[]
---@type Plugins
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    keys = {
      {
        "<leader>fu",
        "<cmd>Telescope undo<cr>",
        desc = "Telescope undo",
      },
    },
    config = function()
      require("telescope").setup({ extensions = { undo = {} } })
      require("telescope").load_extension("undo")
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
                                                                        
                                                                        
                                                                        
                                                                        
                                                                      
       ████ ██████           █████      ██                      
      ███████████             █████                              
      █████████ ███████████████████ ███   ███████████    
     █████████  ███    █████████████ █████ ██████████████    
    █████████ ██████████ █████████ █████ █████ ████ █████    
  ███████████ ███    ███ █████████ █████ █████ ████ █████   
 ██████  █████████████████████ ████ █████ █████ ████ ██████  
                                                                        
                                                                        
                                                                        
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
    --
    --     -- local opts = {
    --     --  theme = "doom",
    --     --  hide = {
    --     --    -- this is taken care of by lualine
    --     --    -- enabling this messes up the actual laststatus setting after loading a file
    --     --    statusline = false,
    --     --  },
    --     --  config = {
    --     --    header = vim.split(logo, "\n"),
    --    end,
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
    cmd = {
      "EditMacros",
      "ClearNeoComposer",
    },
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "nanotee/sqls.nvim",
    cmd = {
      "SqlsExecuteQuery",
      "SqlsExecuteQueryVertical",
      "SqlsShowDatabases",
      "SqlsShowSchemas",
      "SqlsShowConnections",
      "SqlsSwitchDatabase",
      "SqlsSwitchConnection",
    },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      require("lspconfig")["sqls"].setup({
        on_attach = function(client, bufnr)
          require("sqls").on_attach(client, bufnr)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "SqlsConnectionChoice",
        callback = function(event)
          vim.notify(event.data.choice)
        end,
      })
    end,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
      local cfg = require("yaml-companion").setup({
        -- Add any options here, or leave empty to use the default settings
        -- lspconfig = {
        --   cmd = {"yaml-language-server"}
        -- },
      })
      require("lspconfig")["yamlls"].setup(cfg)
    end,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = "yaml",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },
  {
    "kazhala/close-buffers.nvim",
    config = true,
    cmd = "BDelete",
    keys = {
      { "<leader>bo", "<cmd>BDelete! hidden<cr>", desc = "Delete other buffers <close-buffers.nvim>" },
    },
    dependencies = {
      "akinsho/bufferline.nvim",
      keys = {
        -- Disable default keymap of LazyVim
        { "<leader>bo", false, desc = "Delete other buffers" },
      },
    },
  },
  -- {
  --   "drybalka/tree-climber.nvim",
  --   -- config = function()
  --   --   require("tree-climber").setup()
  --   -- end,
  --   keys = {
  --     {
  --       "H",
  --       function()
  --         require("tree-climber").goto_parent()
  --       end,
  --       desc = "Tree Climber: goto parent",
  --     },
  --     {
  --       "L",
  --       function()
  --         require("tree-climber").goto_child()
  --       end,
  --       desc = "Tree Climber: goto child",
  --     },
  --     {
  --       "J",
  --       function()
  --         require("tree-climber").goto_next()
  --       end,
  --       desc = "Tree Climber: goto next",
  --     },
  --     {
  --       "K",
  --       function()
  --         require("tree-climber").goto_prev()
  --       end,
  --       desc = "Tree Climber: goto prev",
  --     },
  --     {
  --       "in",
  --       function()
  --         require("tree-climber").select_node()
  --       end,
  --       desc = "Tree Climber: select node",
  --     },
  --     {
  --       "<c-k>",
  --       function()
  --         require("tree-climber").swap_prev()
  --       end,
  --       desc = "Tree Climber: swap prev",
  --     },
  --     {
  --       "<c-j>",
  --       function()
  --         require("tree-climber").swap_next()
  --       end,
  --       desc = "Tree Climber: swap next",
  --     },
  --     {
  --       "<c-h>",
  --       function()
  --         require("tree-climber").highlight_node()
  --       end,
  --       desc = "Tree Climber: highlight node",
  --     },
  --   },
  -- },
  { -- display value in debug mode
    "theHamsta/nvim-dap-virtual-text",
    event = "BufReadPost",
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },
  { -- tab space
    "tiagovla/scope.nvim",
    config = true,
    event = "TabNew",
    enabled = not vim.g.vscode,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      local ey = require("eyeliner")
      ey.setup({
        highlight_on_key = true, -- show highlights only after keypress
        dim = false, -- dim all other characters if set to true (recommended!)
      })

      vim.api.nvim_set_hl(0, "EyelinerPrimary", { bg = "#78ff64", fg = "black", bold = true, underline = true })
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { bg = "#ff30cf", fg = "black", underline = true })
    end,
    keys = {
      { "f", mode = { "n", "v" }, desc = "Highlight f motion" },
      { "F", mode = { "n", "v" }, desc = "Highlight F motion" },
      { "t", mode = { "n", "v" }, desc = "Highlight t motion" },
      { "T", mode = { "n", "v" }, desc = "Highlight T motion" },
    },
    cmd = "EyelinerEnable",
    dependencies = {
      { "folke/flash.nvim", enabled = false }, -- Disable lazyvim plugin
    },
  },
  { -- fold
    "jghauser/fold-cycle.nvim",
    config = function()
      require("fold-cycle").setup()
    end,
    keys = {
      { "_", "<cmd>lua require('fold-cycle').open()<cr>", desc = "Fold-cycle: open folds" },
      { "-", "<cmd>lua require('fold-cycle').close()<cr>", desc = "Fold-cycle: close folds" },
      { "zC", "<cmd>lua require('fold-cycle').close_all()<cr>", desc = "Fold-cycle: close all folds" },
    },
  },
  {
    "andersevenrud/nvim_context_vt",
    event = "BufReadPost",
    config = function()
      require("nvim_context_vt").setup()
    end,
  },
  {
    "Aasim-A/scrollEOF.nvim",
    event = "CursorMoved",
    config = true,
  },
  { -- color picker
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick" },
    keys = {
      { "<leader><cr>", "<cmd>CccPick<cr>", desc = "Color picker" },
    },
    config = function()
      local ColorInput = require("ccc.input")
      local convert = require("ccc.utils.convert")

      local RgbHslCmykInput = setmetatable({
        name = "RGB/HSL/CMYK",
        max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
        min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        delta = {
          1 / 255,
          1 / 255,
          1 / 255,
          1,
          0.01,
          0.01,
          0.005,
          0.005,
          0.005,
          0.005,
        },
        bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
      }, { __index = ColorInput })

      function RgbHslCmykInput.format(n, i)
        if i <= 3 then
          -- RGB
          n = n * 255
        elseif i == 5 or i == 6 then
          -- S or L of HSL
          n = n * 100
        elseif i >= 7 then
          -- CMYK
          return ("%5.1f%%"):format(math.floor(n * 200) / 2)
        end
        return ("%6d"):format(n)
      end

      function RgbHslCmykInput.from_rgb(RGB)
        local HSL = convert.rgb2hsl(RGB)
        local CMYK = convert.rgb2cmyk(RGB)
        local R, G, B = unpack(RGB)
        local H, S, L = unpack(HSL)
        local C, M, Y, K = unpack(CMYK)
        return { R, G, B, H, S, L, C, M, Y, K }
      end

      function RgbHslCmykInput.to_rgb(value)
        return { value[1], value[2], value[3] }
      end

      function RgbHslCmykInput:_set_rgb(RGB)
        self.value[1] = RGB[1]
        self.value[2] = RGB[2]
        self.value[3] = RGB[3]
      end

      function RgbHslCmykInput:_set_hsl(HSL)
        self.value[4] = HSL[1]
        self.value[5] = HSL[2]
        self.value[6] = HSL[3]
      end

      function RgbHslCmykInput:_set_cmyk(CMYK)
        self.value[7] = CMYK[1]
        self.value[8] = CMYK[2]
        self.value[9] = CMYK[3]
        self.value[10] = CMYK[4]
      end

      function RgbHslCmykInput:callback(index, new_value)
        self.value[index] = new_value
        local v = self.value
        if index <= 3 then
          local RGB = { v[1], v[2], v[3] }
          local HSL = convert.rgb2hsl(RGB)
          local CMYK = convert.rgb2cmyk(RGB)
          self:_set_hsl(HSL)
          self:_set_cmyk(CMYK)
        elseif index <= 6 then
          local HSL = { v[4], v[5], v[6] }
          local RGB = convert.hsl2rgb(HSL)
          local CMYK = convert.rgb2cmyk(RGB)
          self:_set_rgb(RGB)
          self:_set_cmyk(CMYK)
        else
          local CMYK = { v[7], v[8], v[9], v[10] }
          local RGB = convert.cmyk2rgb(CMYK)
          local HSL = convert.rgb2hsl(RGB)
          self:_set_rgb(RGB)
          self:_set_hsl(HSL)
        end
      end

      local ccc = require("ccc")
      local mapping = ccc.mapping

      ccc.setup({
        default_color = "#ffffff",
        inputs = {
          RgbHslCmykInput,
        },
        mappings = {
          t = mapping.toggle_alpha,
          L = mapping.increase5,
          a = mapping.increase10,
          H = mapping.decrease5,
          i = mapping.decrease10,
          I = mapping.set0,
          A = mapping.set100,
        },
      })
    end,
  },
  { -- database client
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { -- align text
    "godlygeek/tabular",
    cmd = "Tabularize",
    keys = { { "a ", mode = "v" }, { "a=", mode = "v" }, { "a:", mode = "v" } },
  },
  { -- translate
    "voldikss/vim-translator",
    cmd = {
      "Translate",
      "TranslateH",
      "TranslateL",
      "TranslateR",
      "TranslateW",
      "TranslateX",
    },
    config = function()
      vim.g.translator_target_lang = "ja"
    end,
  },
  { -- quickfix menu
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "junegunn/fzf",
        build = function()
          vim.fn["fzf#install"]()
        end,
      },
    },
  },
  { -- auto 改行
    "hrsh7th/nvim-insx",
    config = function()
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
  { -- TODO: not working
    "ckolkey/ts-node-action",
    event = "BufRead",
    dependencies = { "nvim-treesitter" },
    opts = {},
  },
  { -- bracket highlight
    "utilyre/sentiment.nvim",
    version = "*",
    event = "CursorMoved", -- keep for lazy loading
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
    keys = {
      { "<Tab>", mode = { "i", "s" } },
      { "<S-Tab>", mode = { "i", "s" } },
    },
    dependencies = { "nvim-treesitter", "nvim-cmp" }, -- or require if not used so far
  },

  { -- move bracket in Insert mode
    "altermo/ultimate-autopair.nvim",
    dependencies = {
      { -- disable lazyvim plugin
        "echasnovski/mini.pairs",
        enabled = false,
      },
    },
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

  { -- zen mode
    "Pocco81/true-zen.nvim",
    cmd = { "TZFocus", "TZNarrow", "TZAtaraxis", "TZMinimalist" },
    config = function()
      require("true-zen").setup({})
    end,
  },

  { -- move window mode
    "sindrets/winshift.nvim",
    cmd = "WinShift",
    keys = {
      {
        "<C-w>[",
        "<cmd>WinShift<cr>",
        desc = "Enter mode of Move window",
      },
    },
    config = function()
      require("winshift").setup()
    end,
  },

  -- AI Plugins -------------------------------------------------
  {
    "Bryley/neoai.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = {
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
    config = function()
      require("chatgpt").setup()
    end,
    cmd = {
      "ChatGPT",
      "ChatGPTRun",
      "ChatGPTActAs",
      "ChatGPTCompleteCode",
      "ChatGPTEditWithInstructions",
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  { -- search word from git commits
    "aaronhallaert/advanced-git-search.nvim",
    cmd = "AdvancedGitSearch",
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
    event = "BufReadPost",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
      })
    end,
  },

  -- {
  --   "folke/trouble.nvim",
  --   cmd = { "TroubleToggle", "Trouble" },
  --   opts = { use_diagnostic_signs = false },
  -- },

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

  { -- add symbols-outline
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
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

  { -- multi cursor
    "mg979/vim-visual-multi",
    branch = "master",
    keys = { { "<C-n>", mode = { "v", "i", "n" } } },
    config = function() end,
    enabled = not vim.g.vscode,
  },

  { -- more useful text object
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

  { -- git client
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
}
