local map = vim.keymap.set

-- Clean (4)
--   ○ baleia.nvim
--   ○ image.nvim
--   ○ mini.pairs
--   ○ nvim-jdtls
--
-- Not Installed (11)
--   ○ action-hints.nvim
--   ○ clear-action.nvim
--   ○ donut.nvim
--   ○ flirt.nvim
--   ○ fugit2.nvim
--   ○ gh-actions.nvim
--   ○ hover.nvim
--   ○ langmapper.nvim
--   ○ quick-code-runner.nvim
--   ○ render-markdown
--   ○ spectacle.nvim
--
-- Loaded (81)
--   ● bufferline.nvim 4.12ms  VeryLazy
--   ● clangd_extensions.nvim 0.56ms 󰢱 clangd_extensions  nvim-lspconfig
--   ● cmp-buffer 12.02ms  nvim-cmp
--   ● cmp-cmdline 1.09ms  nvim-cmp
--   ● cmp-emoji 1.01ms  nvim-cmp
--   ● cmp-nvim-lsp 1.56ms 󰢱 cmp_nvim_lsp  nvim-lspconfig
--   ● cmp-nvim-lsp-document-symbol 1.08ms  nvim-cmp
--   ● cmp-path 0.92ms  nvim-cmp
--   ● conform.nvim 3.93ms 󰢱 conform  LazyVim
--   ● copilot-cmp 4.36ms  nvim-cmp
--   ● copilot.lua 3.63ms  copilot-cmp
--   ● crates.nvim 5.28ms  nvim-cmp
--   ● dashboard-nvim 1.28ms  start
--   ● dressing.nvim 16.93ms  Lazy load
--   ● flash.nvim 1.16ms  VeryLazy
--   ● format-ts-errors.nvim 0.5ms  nvim-lspconfig
--   ● friendly-snippets 0.51ms  nvim-snippets
--   ● gitsigns.nvim 8.39ms  LazyFile
--   ● headlines.nvim 0.21ms  markdown
--   ● indent-blankline.nvim 4.28ms  LazyFile
--   ● lazy-help.nvim 0.86ms  lazy
--   ● lazy.nvim 32.79ms  init.lua
--   ● lazyflex.nvim 0.06ms  start
--   ● LazyVim 4.21ms  start
--   ● lspkind-nvim 0.05ms  nvim-cmp
--   ● lualine.nvim 12.46ms  VeryLazy
--   ● LuaSnip 13.6ms  start
--   ● markid 1.01ms  nvim-treesitter
--   ● mason-lspconfig.nvim 0.07ms  nvim-lspconfig
--   ● mason-nvim-dap.nvim 0.1ms 󰢱 mason-nvim-dap  nvim-dap
--   ● mason.nvim 18.16ms  nvim-lspconfig
--   ● mini.ai 0.68ms  VeryLazy
--   ● mini.bufremove 1.89ms  <C-Q>
--   ● mini.hipatterns 0.53ms  LazyFile
--   ● mini.icons 2.06ms 󰢱 mini.icons  LazyVim
--   ● neo-tree.nvim 21.69ms  <leader>e
--   ● neotest 67.12ms  <leader>tr
--   ● neotest-playwright 2.53ms  neotest
--   ● neotest-python 2.62ms  neotest
--   ● neotest-vitest 2.48ms  neotest
--   ● noice.nvim 2.63ms  start
--   ● nui.nvim 0.21ms  nvim-regexplainer
--   ● nvim-cmp 32.13ms 󰢱 cmp  obsidian.nvim
--   ● nvim-dap 19.11ms 󰢱 dap  nvim-lspconfig
--   ● nvim-dap-go 1.11ms  nvim-dap
--   ● nvim-dap-python 0.73ms  nvim-dap
--   ● nvim-dap-ui 11.12ms  nvim-dap
--   ● nvim-dap-virtual-text 0.74ms  nvim-dap
--   ● nvim-lint 1.48ms  LazyFile
--   ● nvim-lspconfig 65.63ms  garbage-day.nvim
--   ● nvim-metals 0.15ms 󰢱 metals  nvim-lspconfig
--   ● nvim-navic 2.3ms 󰢱 nvim-navic  LazyVim
--   ● nvim-nio 0.4ms  nvim-dap-ui
--   ● nvim-notify 2.11ms 󰢱 notify  noice.nvim
--   ● nvim-snippets 3.6ms  nvim-cmp
--   ● nvim-treesitter 9.93ms  aerial.nvim
--   ● nvim-treesitter-textobjects 2.36ms  VeryLazy
--   ● nvim-ts-autotag 3.15ms  nvim-treesitter
--   ● nvim-window-picker 2.49ms  neo-tree.nvim
--   ● one-small-step-for-vimkind 0.05ms  nvim-dap
--   ● persistence.nvim 2.18ms  BufReadPre
--   ● plenary.nvim 0.57ms 󰢱 plenary.log  telescope-fzf-native.nvim
--   ● project.nvim 1.36ms  VeryLazy
--   ● refactoring.nvim 15.72ms  BufReadPre
--   ● rustaceanvim 2.2ms 󰢱 rustaceanvim.neotest  neotest
--   ● SchemaStore.nvim 0.12ms 󰢱 schemastore  LazyVim
--   ● sqlite.lua 0.63ms  yanky.nvim
--   ● syntax-tree-surfer 6.27ms  va
--   ● tailwindcss-colorizer-cmp.nvim 0.77ms  nvim-cmp
--   ● telescope-fzf-native.nvim 6.23ms  telescope.nvim
--   ● telescope-terraform-doc.nvim 24.63ms  telescope.nvim
--   ● telescope-terraform.nvim 9.56ms  telescope.nvim
--   ● telescope-zoxide 0.15ms  telescope.nvim
--   ● todo-comments.nvim 2.1ms  LazyFile
--   ● tokyonight.nvim 0.73ms 󰢱 tokyonight  LazyVim
--   ● trouble.nvim 2.41ms 󰢱 trouble  lualine.nvim
--   ● ts-comments.nvim 0.77ms  VeryLazy
--   ● vim-illuminate 1.63ms  start
--   ● vimtex 1.14ms  start
--   ● which-key.nvim 1.79ms 󰢱 which-key  nvim-regexplainer
--   ● yanky.nvim 28.84ms  LazyFile
--
-- Not Loaded (115)
--   ○ activate.nvim
--   ○ advanced-git-search.nvim
--   ○ aerial.nvim
--   ○ calvera-dark.nvim
--   ○ catppuccin
--   ○ ccc.nvim
--   ○ ChatGPT.nvim
--   ○ close-buffers.nvim
--   ○ code-refactor.nvim
--   ○ command-and-cursor.nvim
--   ○ CopilotChat.nvim
--   ○ core.nvim  git-log.nvim
--   ○ decisive.nvim
--   ○ diffview.nvim  neogit
--   ○ edit-markdown-table.nvim
--   ○ eyeliner.nvim
--   ○ flatten.nvim
--   ○ fold-cycle.nvim
--   ○ fzf  nvim-bqf
--   ○ fzf-lua  neogit
--   ○ garbage-day.nvim
--   ○ genius.nvim
--   ○ git-conflict.nvim
--   ○ git-log.nvim
--   ○ gp.nvim
--   ○ GPTModels.nvim
--   ○ kiwi.nvim
--   ○ kubectl.nvim
--   ○ lazydev.nvim  lua  LazyDev
--   ○ leap.nvim  telepath.nvim
--   ○ lsplinks.nvim
--   ○ lspsaga.nvim
--   ○ luvit-meta
--   ○ markdown-preview.nvim  <leader>cp  MarkdownPreviewStop  MarkdownPreviewToggle  MarkdownPreview
--   ○ marknav.nvim
--   ○ middleclass  windows.nvim
--   ○ mini.files  <leader>fM  <leader>fm
--   ○ mini.nvim
--   ○ minimap.vim
--   ○ muren.nvim
--   ○ neo-minimap
--   ○ neoai.nvim
--   ○ NeoComposer.nvim
--   ○ neogit
--   ○ nvim-bqf
--   ○ nvim-dbee
--   ○ nvim-insx
--   ○ nvim-lightbulb
--   ○ nvim-regexplainer
--   ○ nvim-spectre  <leader>sr  Spectre
--   ○ nvim-spider
--   ○ nvim-tinygit  fugit2.nvim
--   ○ nvim-web-devicons  oil.nvim  lspsaga.nvim  fugit2.nvim  aerial.nvim  octo.nvim  trouble.nvim
--   ○ nvim_rocks  nvim-spider
--   ○ obsidian.nvim
--   ○ octo.nvim
--   ○ oil.nvim
--   ○ oldworld.nvim
--   ○ outline.nvim  <leader>cs  Outline
--   ○ peek.nvim
--   ○ playground  TSPlaygroundToggle
--   ○ pomo.nvim
--   ○ pretty_hover
--   ○ rabbit.nvim
--   ○ reactive.nvim
--   ○ replacer.nvim
--   ○ satellite.nvim
--   ○ scope.nvim
--   ○ scrollEOF.nvim
--   ○ sentiment.nvim
--   ○ smart-splits.nvim
--   ○ ssr.nvim
--   ○ sunglasses.nvim
--   ○ symbol-usage.nvim
--   ○ tabout.nvim
--   ○ tabular
--   ○ tailwind-tools.nvim
--   ○ tardis.nvim
--   ○ telepath.nvim
--   ○ telescope-ghq.nvim  telescope.nvim
--   ○ telescope-import.nvim
--   ○ telescope-undo.nvim  telescope.nvim
--   ○ termim.nvim
--   ○ toggleterm.nvim
--   ○ trailblazer.nvim
--   ○ transparent.nvim
--   ○ tree-sitter-just
--   ○ TreePin
--   ○ treesitter-indent-object.nvim  ai (o)  aI (x)  aI (o)  ii (x)  ii (o)  iI (x)  iI (o)  ai (x)
--   ○ true-zen.nvim
--   ○ ts-error-translator.nvim
--   ○ ts-node-action
--   ○ tsc.nvim
--   ○ tw-values.nvim
--   ○ typecheck.nvim
--   ○ typst-preview.nvim
--   ○ ultimate-autopair.nvim
--   ○ undotree
--   ○ venv-selector.nvim  <leader>cv  python  VenvSelect
--   ○ vim-dadbod  vim-dadbod-ui
--   ○ vim-dadbod-ui
--   ○ vim-fugitive  advanced-git-search.nvim
--   ○ vim-helm  helm
--   ○ vim-rhubarb  advanced-git-search.nvim
--   ○ vim-translator
--   ○ vim-visual-multi
--   ○ vim-wakatime
--   ○ visual-whitespace.nvim
--   ○ wf.nvim
--   ○ whaler
--   ○ windows.nvim
--   ○ winshift.nvim
--   ○ wtf.nvim
--   ○ yaml-companion.nvim
--   ○ zone.nvim
--
-- Disabled (1)
--   ○ mini.pairs
--
---@alias Plugins plugins.Plugin[]
---@type Plugins
---
return {
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      -- "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 50
      vim.o.winminwidth = 4
      vim.o.equalalways = false
      require("windows").setup()
    end,
  },
  -- {
  --   "Wansmer/langmapper.nvim",
  --   lazy = false,
  --   priority = 1, -- High priority is needed if you will use `autoremap()`
  --   config = function()
  --     require("langmapper").setup({--[[ your config ]]
  --     })
  --   end,
  -- },
  { -- scroll bar
    "lewis6991/satellite.nvim",
    opts = {
      current_only = true,
    },
  },
  { -- macro manager
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
  },
  {
    "kiran94/edit-markdown-table.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "EditMarkdownTable",
  },
  -- {
  --   "topaxi/gh-actions.nvim",
  --   cmd = "GhActions",
  --   keys = {
  --     { "<leader>gh", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
  --   },
  --   -- optional, you can also install and use `yq` instead.
  --   build = "make",
  --   dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  --   opts = {},
  --   config = function(_, opts)
  --     require("gh-actions").setup(opts)
  --   end,
  -- },
  -- { -- session manager
  --   "RutaTang/spectacle.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   opts = {
  --     -- "/path/of/dir/where/you/want/to/save/all/sessions"
  --     session_dir = vim.fn.stdpath("data") .. "/sessions",
  --   },
  -- },
  {
    "KaitlynEthylia/TreePin",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("treepin").setup()
    end,
  },
  {
    "serenevoid/kiwi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- { -- floating window manager
  --   "tamton-aquib/flirt.nvim",
  --   opts = {
  --     speed = 100, -- animation speed
  --   },
  -- },
  { "tamton-aquib/zone.nvim" },
  { -- Replace text in quickfix list
    "gabrielpoca/replacer.nvim",
    config = function()
      require("replacer").setup()
      -- TODO: integrate with telescope
    end,
  },
  { -- Show all tailwind CSS value  of component
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
    opts = {
      border = "rounded", -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
      focus_preview = true, -- Sets the preview as the current window
      copy_register = "", -- The register to copy values to,
      keymaps = {
        copy = "<C-y>", -- Normal mode keymap to copy the CSS values between {}
      },
    },
  },
  { -- TODO: disable which-key
    "Cassin01/wf.nvim",
    version = "*",
    opts = {},
  },
  { -- smart window manager
    "mrjones2014/smart-splits.nvim",
    -- TODO: keymap
  },
  {
    "roobert/activate.nvim",
    -- keys = {
    --   {
    --     "<leader>P",
    --     '<CMD>lua require("activate").list_plugins()<CR>',
    --     desc = "Plugins",
    --   },
    -- },
    dependencies = {
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
  },
  { -- Show Symbol and reference of LSP
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require("symbol-usage").setup()
    end,
  },
  {
    "chrisgrieser/nvim-tinygit",
    ft = { "git_rebase", "gitcommit" }, -- so ftplugins are loaded
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim", -- either telescope or fzf-lua
      -- "ibhagwan/fzf-lua",
      "rcarriga/nvim-notify", -- optional, but will lack some features without it
    },
  },
  -- { -- Show LSP action
  --   "luckasRanarison/clear-action.nvim",
  --   opts = {},
  -- },
  -- { -- Show LSP action
  --   "roobert/action-hints.nvim",
  --   config = function()
  --     require("action-hints").setup()
  --   end,
  -- },
  { -- project switcher
    "SalOrak/whaler",
    config = function()
      -- Telescope setup()
      local telescope = require("telescope")
      telescope.setup({
        -- Your telescope setup here...
        extensions = {
          whaler = {
            -- Whaler configuration
            directories = { "path/to/dir", "path/to/another/dir", { path = "path/to/yet/another/dir", alias = "yet" } },
            -- You may also add directories that will not be searched for subdirectories
            oneoff_directories = {
              "path/to/project/folder",
              { path = "path/to/another/project", alias = "Project Z" },
            },
          },
        },
      })
      -- More config here
      telescope.load_extension("whaler")
      --

      -- Open whaler using <leader>fw
      -- vim.keymap.set("n", "<leader>fw", function()
      --     local w = telescope.extensions.whaler.whaler
      --     w({
      --         -- Settings can also be called here.
      --         -- These would use but not change the setup configuration.
      --     })
      --  end,)

      -- Or directly
      vim.keymap.set("n", "<leader>fw", telescope.extensions.whaler.whaler)
    end,
  },
  -- { -- LSP manager
  --   "hinell/lsp-timeout.nvim",
  --   dependencies = { "neovim/nvim-lspconfig" },
  -- },
  -- { -- FIXME:
  --   "edluffy/hologram.nvim",
  --   config = function()
  --     require("hologram").setup({
  --       auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
  --     })
  --   end,
  -- },
  { "miversen33/sunglasses.nvim", config = true },
  {
    "hedyhli/outline.nvim",
    opts = {},
  },
  { "IndianBoy42/tree-sitter-just" },
  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    -- Calling setup is optional.
    config = function()
      require("ssr").setup({
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      })
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    lazy = false, -- or ft = 'typst'
    version = "0.3.*",
    build = function()
      require("typst-preview").update()
    end,
  },
  {
    "rasulomaroff/reactive.nvim",
    config = function()
      require("reactive").setup({
        builtin = {
          cursorline = true,
          cursor = true,
          modemsg = true,
        },
      })
    end,
  },
  { -- A Neovim plugin designed to enhance your Markdown navigation experience.
    "daenikon/marknav.nvim",
    ft = { "markdown", "md" },
    opts = {},
  },
  -- { -- AI client FIXME: error occurs
  --   "gsuuon/model.nvim",
  --   -- Don't need these if lazy = false
  --   cmd = { "M", "Model", "Mchat" },
  --   init = function()
  --     vim.filetype.add({
  --       extension = {
  --         mchat = "mchat",
  --       },
  --     })
  --   end,
  --   ft = "mchat",
  --
  --   keys = {
  --     { "<C-m>d", ":Mdelete<cr>", mode = "n" },
  --     { "<C-m>s", ":Mselect<cr>", mode = "n" },
  --     { "<C-m><space>", ":Mchat<cr>", mode = "n" },
  --   },
  -- },
  { -- database client
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    opts = {},
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    config = true,
  },
  { -- lazy load docs
    "phanen/lazy-help.nvim",
    ft = "lazy",
  },
  -- {
  --   "fnune/recall.nvim",
  --   opts = {},
  -- },
  -- -- {
  -- --   "Rentib/cliff.nvim",
  -- --   keys = {
  -- --     {
  -- --       "<c-j>",
  -- --       mode = { "n", "v", "o" },
  -- --       function()
  -- --         require("cliff").go_down()
  -- --       end,
  -- --     },
  -- --     {
  -- --       "<c-k>",
  -- --       mode = { "n", "v", "o" },
  -- --       function()
  -- --         require("cliff").go_up()
  -- --       end,
  -- --     },
  -- --   },
  -- -- },
  -- {
  --   "mvllow/modes.nvim",
  --   tag = "v0.2.0",
  --   config = function()
  --     require("modes").setup({
  --       line_opacity = 0.45,
  --     })
  --   end,
  -- },
  {
    "rasulomaroff/telepath.nvim",
    dependencies = "ggandor/leap.nvim",
    -- there's no sense in using lazy loading since telepath won't load the main module
    -- until you actually use mappings
    lazy = false,
    config = function()
      require("telepath").use_default_mappings()
    end,
  },
  {
    "icholy/lsplinks.nvim",
    config = function()
      local lsplinks = require("lsplinks")
      lsplinks.setup()
      -- vim.keymap.set("n", "gx", lsplinks.gx)
    end,
  },
  {
    "snehlsen/pomo.nvim",
    config = true,
  },
  {
    "2kabhishek/termim.nvim",
    cmd = { "Fterm", "FTerm", "Sterm", "STerm", "Vterm", "VTerm" },
  },
  -- {
  --   "marilari88/twoslash-queries.nvim",
  --   config = function()
  --     require("twoslash-queries").setup({
  --       multi_line = true, -- to print types in multi line mode
  --       is_enabled = false, -- to keep disabled at startup and enable it on request with the TwoslashQueriesEnable
  --       highlight = "Type", -- to set up a highlight group for the virtual text
  --     })
  --   end,
  --   -- NOTE: これが必要かも
  --   --     require("lspconfig")["tsserver"].setup({
  --   --     on_attach = function(client, bufnr)
  --   --        require("twoslash-queries").attach(client, bufnr)
  --   --     end,
  --   -- })
  -- },
  -- {
  --   "dlvhdr/gh-addressed.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "folke/trouble.nvim",
  --   },
  --   cmd = "GhReviewComments",
  --   keys = {
  --     { "<leader>gc", "<cmd>GhReviewComments<cr>", desc = "GitHub Review Comments" },
  --   },
  -- },
  -- {
  --   "dlvhdr/gh-blame.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  --   keys = {
  --     { "<leader>gg", "<cmd>GhBlameCurrentLine<cr>", desc = "GitHub Blame Current Line" },
  --   },
  -- },
  { -- File git history inspector
    "fredeeb/tardis.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  { -- File git history inspector
    "niuiic/git-log.nvim",
    dependencies = {
      { "niuiic/core.nvim" },
    },
    config = function()
      require("git-log").setup()
    end,
  },
  { -- Automatically update mappings when they are changed in a file.
    --   "numToStr/ReplaceWithRegister.nvim",
    --
  },
  { -- hilgiht select line when command mode
    "moyiz/command-and-cursor.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- { -- indent hilgiht
  --   "Mr-LLLLL/cool-chunk.nvim",
  --   event = { "CursorHold", "CursorHoldI" },
  --   dependencies = {
  --     "nvem-treesitter/nvim-treesitter",
  --   },
  --   opts = {},
  -- },
  { "yashguptaz/calvera-dark.nvim" },
  -- {
  --   "Pocco81/auto-save.nvim",
  --   config = function()
  --     require("auto-save").setup({
  --       -- your config goes here
  --       -- or just leave it empty :)
  --     })
  --   end,
  -- },
  { "dmmulroy/ts-error-translator.nvim" },
  -- {
  --   "ObserverOfTime/notifications.nvim",
  --   opts = {
  --     override_notify = true,
  --     hist_command = "Notifications",
  --     -- or set `icons = false` to disable all icons
  --     icons = {
  --       TRACE = "", -- '🔍',
  --       DEBUG = "󰠭", -- '🐞',
  --       INFO = "", -- '📣',
  --       WARN = "", -- '⚠️ ',
  --       ERROR = "", -- '🚨',
  --       OFF = "", -- '⛔',
  --     },
  --     hl_groups = {
  --       TRACE = "DiagnosticFloatingHint",
  --       DEBUG = "DiagnosticFloatingHint",
  --       INFO = "DiagnosticFloatingInfo",
  --       WARN = "DiagnosticFloatingWarn",
  --       ERROR = "DiagnosticFloatingError",
  --       OFF = "DiagnosticFloatingOk",
  --     },
  --   },
  --   -- to use OSC 777/99/9:
  --   --[[
  -- config = function(_, opts)
  --   vim.g.notifications_use_osc = '777'
  --   require('notifications').setup(opts)
  -- end
  -- --]]
  -- },
  { -- colorschema
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
  },
  -- {
  --   "jellydn/quick-code-runner.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   opts = {
  --     debug = true,
  --   },
  --   cmd = { "QuickCodeRunner", "QuickCodePad" },
  --   keys = {
  --     {
  --       "<leader>cr",
  --       ":QuickCodeRunner<CR>",
  --       desc = "Quick Code Runner",
  --       mode = "v",
  --     },
  --     {
  --       "<leader>cp",
  --       ":QuickCodePad<CR>",
  --       desc = "Quick Code Pad",
  --     },
  --   },
  -- },
  {
    "jellydn/typecheck.nvim",
    dependencies = { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    ft = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact" },
    opts = {
      debug = true,
      mode = "trouble", -- "quickfix" | "trouble"
    },
    keys = {
      {
        "<leader>ck",
        "<cmd>Typecheck<cr>",
        desc = "Run Type Check",
      },
    },
  },
  {
    "voxelprismatic/rabbit.nvim",
    opts = {},
  },
  -- {
  --   "SergioRibera/codeshot.nvim",
  --   config = function()
  --     require("codeshot").setup({})
  --   end,
  -- },
  -- TODO: Add your plugins here
  -- SergioRibera/cmp-dotenv
  -- cmpletion from envrioment variables
  {
    "Aaronik/GPTModels.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  -- {
  --   "lewis6991/hover.nvim",
  --   config = function()
  --     require("hover").setup({
  --       init = function()
  --         -- Require providers
  --         require("hover.providers.lsp")
  --         -- require('hover.providers.gh')
  --         -- require('hover.providers.gh_user')
  --         -- require('hover.providers.jira')
  --         -- require('hover.providers.dap')
  --         -- require('hover.providers.diagnostic')
  --         -- require('hover.providers.man')
  --         -- require('hover.providers.dictionary')
  --       end,
  --       preview_opts = {
  --         border = "single",
  --       },
  --       -- Whether the contents of a currently open hover window should be moved
  --       -- to a :h preview-window when pressing the hover keymap.
  --       preview_window = false,
  --       title = true,
  --       mouse_providers = {
  --         "LSP",
  --       },
  --       mouse_delay = 1000,
  --     })
  --
  --     -- Setup keymaps
  --     vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
  --     vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
  --     vim.keymap.set("n", "<C-p>", function()
  --       require("hover").hover_switch("previous")
  --     end, { desc = "hover.nvim (previous source)" })
  --     vim.keymap.set("n", "<C-n>", function()
  --       require("hover").hover_switch("next")
  --     end, { desc = "hover.nvim (next source)" })
  --
  --     -- Mouse support
  --     vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
  --     vim.o.mousemoveevent = true
  --   end,
  -- },
  -- Lazy
  {
    "piersolenski/telescope-import.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").load_extension("import")
    end,
  },
  -- {
  --   "atusy/treemonkey.nvim",
  --   init = function()
  --     vim.keymap.set({ "x", "o" }, "m", function()
  --       require("treemonkey").select({ ignore_injections = false })
  --     end)
  --   end,
  -- },
  {
    "jdrupal-dev/code-refactor.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>cc", "<cmd>CodeActions all<CR>", desc = "Show code-refactor.nvim (not LSP code actions)" },
    },
    config = function()
      require("code-refactor").setup({
        -- Configuration here, or leave empty to use defaults.
      })
    end,
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
  },
  -- {
  --   "NStefan002/donut.nvim",
  --   version = "*",
  --   lazy = false,
  --   opts = {
  --     timeout = 240,
  --   },
  -- },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {}, -- your configuration
  },
  {
    -- CSV
    "emmanueltouzery/decisive.nvim",
  },
  {
    "ramilito/kubectl.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>k",
        function()
          require("kubectl").open()
        end,
        desc = "Kubectl",
      },
    },
    config = function()
      require("kubectl").setup()
    end,
  },
  -- {
  --   "SuperBo/fugit2.nvim",
  --   opts = {
  --     width = 70,
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "chrisgrieser/nvim-tinygit", -- optional: for Github PR view
  --       dependencies = { "stevearc/dressing.nvim" },
  --     },
  --   },
  --   cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
  --   -- keys = {
  --   --   { "<leader>F", mode = "n", "<cmd>Fugit2<cr>" },
  --   -- },
  -- },
  {
    "AckslD/muren.nvim",
    config = true,
  },
  -- {
  --   "lewis6991/whatthejump.nvim",
  --   config = true,
  --   -- opts = {},
  -- },
  {
    "bennypowers/nvim-regexplainer",
    config = function()
      require("regexplainer").setup({
        auto = false,
        mapping = {
          toggle = "gR",
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  -- {
  --   "tiagovla/tokyodark.nvim",
  --   opts = {
  --     -- custom options here
  --   },
  --   config = function(_, opts)
  --     require("tokyodark").setup(opts) -- calling setup is optional
  --     vim.cmd([[colorscheme tokyodark]])
  --   end,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ghq.nvim",
    },
    keys = {
      {
        "<leader>ghq",
        "<cmd>Telescope ghq list<cr>",
        desc = "List ghq repositories",
      },
    },
    config = function()
      require("telescope").load_extension("ghq")
    end,
  },
  {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "ziontee113/neo-minimap",
    config = function()
      -- for shorthand usage
      local nm = require("neo-minimap")

      nm.setup_defaults({
        height = 30,
        width = 80,
        height_toggle = { 30, 55 },
      })

      nm.set({ "zi", "zo", "zu" }, "*.lua", {
        events = { "BufEnter" },

        query = {
          [[
    ;; query
    ;; ((function_declaration name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((function_call name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((dot_index_expression field: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]],
          1,
          --       [[
          -- ;; query
          -- ((function_declaration) @cap)
          -- ((assignment_statement(expression_list((function_definition) @cap))))
          -- ((field (identifier) @cap) (#eq? @cap "keymaps"))
          -- ]],
          --       [[
          -- ;; query
          -- ((for_statement) @cap)
          -- ((function_declaration) @cap)
          -- ((assignment_statement(expression_list((function_definition) @cap))))
          --
          -- ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
          -- ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
          -- ]],
          --       [[
          -- ;; query
          -- ((for_statement) @cap)
          -- ((function_declaration) @cap)
          -- ((assignment_statement(expression_list((function_definition) @cap))))
          -- ]],
        },

        regex = {
          {},
          { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
          { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
          {},
        },

        search_patterns = {
          { "function", "<C-j>", true },
          { "function", "<C-k>", false },
          { "keymap", "<A-j>", true },
          { "keymap", "<A-k>", false },
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },
        disable_indentaion = true,
      })
      nm.set("zi", "typescriptreact", { -- press `zi` to open the minimap, in `typescriptreact` files
        query = [[
;; query
((function_declaration) @cap) ;; matches function declarations
((arrow_function) @cap) ;; matches arrow functions
((identifier) @cap (#vim-match? @cap "^use.*")) ;; matches hooks (useState, useEffect, use***, etc...)
  ]],
      })
    end,
  },
  -- Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
  {
    "wfxr/minimap.vim",
    build = ":!cargo install --locked code-minimap",
    cmd = {
      "Minimap",
      "MinimapClose",
      "MinimapToggle",
      "MinimapRefresh",
      "MinimapUpdateHighlight",
      "MinimapRescan",
    },
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    cmd = {
      "PeekOpen",
      "PeekClose",
    },
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  -- {
  --   "MeanderingProgrammer/markdown.nvim",
  --   name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("render-markdown").setup({})
  --   end,
  -- },
  {
    "archibate/genius.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("genius").setup({
        completion_delay_ms = 800, -- microseconds before completion triggers, set this to -1 to disable and only allows manual trigger
        -- This plugin supports many backends, openai backend is the default:
        default_bot = "openai",
        -- You may obtain an API key from OpenAI as long as you have an account: https://platform.openai.com/account/api-keys
        -- Either set the environment variable OPENAI_API_KEY in .bashrc, or set api_key option in the setup here:
        --
        config_openai = {
          api_key = os.getenv("OPENAI_API_KEY"),
          infill_options = {
            max_tokens = 100, -- maximum number of tokens allowed to generate in a single completion
            model = "gpt-3.5-turbo-instruct", -- must be instruct model here, no chat models! you may only replace this with code-davinci-002 for example
            temperature = 0.8, -- temperature varies from 0 to 1, higher means more random (and more funny) results
          },
        },
        -- Otherwise, you may run DeepSeek-Coder locally instead:
        -- default_bot = 'deepseek',
        -- See sections below for detailed instructions on setting up this model.
      })
    end,
  },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
  },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
  { "dmmulroy/tsc.nvim", cmd = { "TSC" } },
  { -- better typescript diagnostic
    "dmmulroy/ts-error-translator.nvim",
    auto_override_publish_diagnostics = true,
  },
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      -- your options here
    },
  },
  {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
        debug = true, -- Enable debugging
      },

      --     :CopilotChat <input>? - Open chat window with optional input
      --     :CopilotChatOpen - Open chat window
      --     :CopilotChatClose - Close chat window
      --     :CopilotChatToggle - Toggle chat window
      --     :CopilotChatReset - Reset chat window
      --     :CopilotChatSave <name>? - Save chat history to file
      --     :CopilotChatLoad <name>? - Load chat history from file
      --     :CopilotChatDebugInfo - Show debug information
      --
      -- Commands coming from default prompts
      --
      --     :CopilotChatExplain - Explain how it works
      --     :CopilotChatTests - Briefly explain how selected code works then generate unit tests
      --     :CopilotChatFix - There is a problem in this code. Rewrite the code to show it with the bug fixed.
      --     :CopilotChatOptimize - Optimize the selected code to improve performance and readablilty.
      --     :CopilotChatDocs - Write documentation for the selected code. The reply should be a codeblock containing the original code with the documentation added as comments. Use the most appropriate documentation style for the programming language used (e.g. JSDoc for JavaScript, docstrings for Python etc.
      --     :CopilotChatFixDiagnostic - Please assist with the following diagnostic issue in file
      --     :CopilotChatCommit - Write commit message for the change with commitizen convention
      --     :CopilotChatCommitStaged - Write commit message for the change with commitizen convention
      cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatReset",
        "CopilotChatSave",
        "CopilotChatLoad",
        "CopilotChatDebugInfo",
        "CopilotChatExplain",
        "CopilotChatTests",
        "CopilotChatFix",
        "CopilotChatOptimize",
        "CopilotChatDocs",
        "CopilotChatFixDiagnostic",
        "CopilotChatCommit",
        "CopilotChatCommitStaged",
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },
  -- use your favorite package manager to install, for example in lazy.nvim
  --  Optionally, you can also install nvim-telescope/telescope.nvim to use some search functionality.
  -- {
  --   {
  --     "sourcegraph/sg.nvim",
  --     dependencies = {
  --       "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
  --     },
  --   },
  -- },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/obsidian-vault",
        },
      },

      -- see below for full list of options 👇
    },
  },
  { "echasnovski/mini.nvim", version = "*" },
  -- {
  --   "folke/twilight.nvim",
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --     alpha = 0.8, -- amount of dimming
  --   },
  --   keys = { { "<leader>ul", "<cmd>Twilight<cr>", desc = "Highlight code" } },
  -- },
  {
    "willothy/flatten.nvim",
    opts = {
      {
        "willothy/flatten.nvim",
        config = true,
        -- or pass configuration with
        -- opts = {  }
        -- Ensure that it runs first to minimize delay when opening file from terminal
        lazy = false,
        priority = 1001,
      },
      --- ...
    },
    update = ":Rocks install flatten.nvim",
  },
  { -- diagnostic fixer
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    keys = {
      {
        "gw",
        mode = { "n", "x" },
        function()
          require("wtf").ai()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        mode = { "n" },
        "gW",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
    },
  },
  {
    "2kabhishek/termim.nvim",
    cmd = { "Fterm", "FTerm", "Sterm", "STerm", "Vterm", "VTerm" },
  },
  -- {
  --   "phaazon/hop.nvim",
  --   branch = "v2", -- optional but strongly recommended
  --   config = function()
  --     -- you can configure Hop the way you like here; see :h hop-config
  --     require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
  --   end,
  -- },
  { -- auto 改行
    "hrsh7th/nvim-insx",
    config = function()
      require("insx.preset.standard").setup()
      local insx = require("insx")
      -- Simple pair deletion recipe.
      -- local function your_recipe(option)
      --   return {
      --     action = function(ctx)
      --       if option.allow_space then
      --         ctx.remove([[\s*\%#\s*]])
      --       end
      --       ctx.send("<BS><Right><BS>")
      --     end,
      --     enabled = function(ctx)
      --       if option.allow_space then
      --         return ctx.match([[(\s*\%#\s*)]])
      --       end
      --       return ctx.match([[(\%#)]])
      --     end,
      --   }
      -- end
      -- require("insx").add(
      --   "<C-j>",
      --   require("insx.recipe.fast_wrap")({
      --     close = ")",
      --   })
      -- )

      -- insx.add(
      --   "<C-z>",
      --   require("insx.recipe.fast_wrap")({
      --     close = ")",
      --   })
      -- )
      -- Simple pair deletion recipe.
      --
    end,
  },
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   config = function()
  --     require("telescope").load_extension("frecency")
  --   end,
  --   keys = {
  --     {
  --       "<Leader><Leader>",
  --       "<cmd>Telescope frecency<CR>",
  --       "Telescope frequent",
  --     },
  --   },
  -- },
  {
    "towolf/vim-helm",
  },
  -- {
  --   "kawre/leetcode.nvim",
  --   build = ":TSUpdate html",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim", -- required by telescope
  --     "MunifTanjim/nui.nvim",
  --
  --     -- optional
  --     "nvim-treesitter/nvim-treesitter",
  --     "rcarriga/nvim-notify",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     -- getenv
  --     storage = {
  --       home = os.getenv("HOME") .. "/workspace/leetcode",
  --     },
  --     -- configuration goes here
  --     lang = "typescript",
  --   },
  -- },
  -- Using packer
  {
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
      require("trailblazer").setup({})
    end,
    -- :TrailBlazerNewTrailMark 	<window? number>
    -- <buffer? string | number>
    -- <cursor_pos_row? number>
    -- <cursor_pos_col? number> 	Create a new / toggle existing trail mark at the current cursor position or at the specified window / buffer / position.
    -- :TrailBlazerTrackBack 	<buffer? string | number> 	Move to the last global trail mark or the last one within the specified buffer and remove it from the trail mark stack.
    -- :TrailBlazerPeekMovePreviousUp 	<buffer? string | number 	Move to the previous global trail mark or the previous one within the specified buffer leading up to the oldest one without removing it from the trail mark stack. In chronologically sorted trail mark modes this will move the trail mark cursor up.
    -- :TrailBlazerPeekMoveNextDown 	<buffer? string | number> 	Move to the next global trail mark or the next one within the specified buffer leading up to the newest one without removing it from the trail mark stack. In chronologically sorted trail mark modes this will move the trail mark cursor down.
    -- :TrailBlazerMoveToNearest 	<buffer? string | number>
    -- <directive? string>
    -- <dist_type? string> 	Move to the nearest trail mark in the current or the nearest trail mark within the specified buffer. This calculates either the minimum Manhattan Distance or the minimum linear character distance between the current cursor position and the qualifying trail marks depending on dist_type => ("man_dist", "lin_char_dist"). Passing one of the available motion directives to this command will change the behavior of this motion.
    -- :TrailBlazerMoveToTrailMarkCursor 		Move to the trail mark cursor in the current stack.
    -- :TrailBlazerDeleteAllTrailMarks 	<buffer? string | number> 	Delete all trail marks globally or within the specified buffer.
    -- :TrailBlazerPasteAtLastTrailMark 	<buffer? string | number> 	Paste the contents of any selected register at the last global trail mark or the last one within the specified buffer and remove it from the trail mark stack.
    -- :TrailBlazerPasteAtAllTrailMarks 	<buffer? string | number> 	Paste the contents of any selected register at all global trail marks or at all trail marks within the specified buffer.
    -- :TrailBlazerTrailMarkSelectMode 	<mode? string> 	Cycle through or set the current trail mark selection mode.
    -- :TrailBlazerToggleTrailMarkList 	<type? string>
    -- <buffer? string | number> 	Toggle a global list of all trail marks or a subset within the given buffer. If no arguments are specified the current trail mark selection mode will be used to populate the list with either a subset or all trail marks in the mode specific order.
    -- :TrailBlazerOpenTrailMarkList 	<type? string>
    -- <buffer? string | number> 	Open a global list of all trail marks or a subset within the given buffer. If no arguments are specified the current trail mark selection mode will be used to populate the list with either a subset or all trail marks in the mode specific order.
    -- :TrailBlazerCloseTrailMarkList 	<type? string> 	Close the specified trail mark list. If no arguments are specified all lists will be closed.
    -- :TrailBlazerSwitchTrailMarkStack 	<stack_name? string> 	Switch to the specified trail mark stack. If no stack under the specified name exists, it will be created. If no arguments are specified the default stack will be selected.
    -- :TrailBlazerAddTrailMarkStack 	<stack_name? string> 	Add a new trail mark stack. If no arguments are specified the default stack will be added to the list of trail mark stacks.
    -- :TrailBlazerDeleteTrailMarkStacks 	<stack_name? string>
    -- ... 	Delete the specified trail mark stacks. If no arguments are specified the current trail mark stack will be deleted.
    -- :TrailBlazerDeleteAllTrailMarkStacks 		Delete all trail mark stacks.
    -- :TrailBlazerSwitchNextTrailMarkStack 	<sort_mode? string> 	Switch to the next trail mark stack using the specified sorting mode. If no arguments are specified the current default sort mode will be used.
    -- :TrailBlazerSwitchPreviousTrailMarkStack 	<sort_mode? string> 	Switch to the previous trail mark stack using the specified sorting mode. If no arguments are specified the current default sort mode will be used.
    -- :TrailBlazerSetTrailMarkStackSortMode 	<sort_mode? string> 	Cycle through or set the current trail mark stack sort mode.
    -- :TrailBlazerSaveSession 	<session_path? string> 	Save all trail mark stacks and and the current configuration to a session file. If no arguments are specified the session will be saved in the default session directory. You will find more information here.
    -- :TrailBlazerLoadSession 	<session_path? string> 	Load a previous session from a session file. If no arguments are specified the session will be loaded from the default session directory. You will find more information here.
    -- :TrailBlazerDeleteSession 	<session_path? string> 	Delete any valid session file. If no arguments are specified the session will be deleted from the default session directory. You will find more information here.
    keys = {
      {
        "<leader>j",
        "<cmd>TrailBlazerNewTrailMark<cr>",
      },
      {
        "<C-j>",
        "<cmd>TrailBlazerTrackBack<cr>",
      },
      {
        "<C-h>",
        "<cmd>TrailBlazerPeekMovePreviousUp<cr>",
      },
      {
        "<C-l>",
        "<cmd>TrailBlazerPeekMoveNextDown<cr>",
      },
      {
        "<C-l>",
        "<cmd>TrailBlazerPeekMoveNextDown<cr>",
      },
    },
  },
  -- lazy.nvim
  {
    "robitx/gp.nvim",
    config = function()
      require("gp").setup()

      -- or setup with your own config (see Install > Configuration in Readme)
      -- require("gp").setup(config)

      -- shortcuts might be setup here (see Usage > Shortcuts in Readme)
    end,
  },
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
  -- { LSP client of SQL
  --   "nanotee/sqls.nvim",
  --   cmd = {
  --     "SqlsExecuteQuery",
  --     "SqlsExecuteQueryVertical",
  --     "SqlsShowDatabases",
  --     "SqlsShowSchemas",
  --     "SqlsShowConnections",
  --     "SqlsSwitchDatabase",
  --     "SqlsSwitchConnection",
  --   },
  --   ft = { "sql", "mysql", "plsql" },
  --   config = function()
  --     require("lspconfig")["sqls"].setup({
  --       on_attach = function(client, bufnr)
  --         require("sqls").on_attach(client, bufnr)
  --       end,
  --     })
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "SqlsConnectionChoice",
  --       callback = function(event)
  --         vim.notify(event.data.choice)
  --       end,
  --     })
  --   end,
  -- },
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
      {
        "folke/flash.nvim",
        opts = {
          modes = {
            char = {
              enabled = false,
              keys = {},
            },
          },
        },
      }, -- Disable lazyvim plugin
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
  -- {
  --   "andersevenrud/nvim_context_vt",
  --   event = "BufReadPost",
  --   config = function()
  --     require("nvim_context_vt").setup()
  --   end,
  -- },
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
      -- { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
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
    keys = {
      { "<leader>a", ":Tabularize /", desc = "Align text", mode = "v" },
    },
    -- keys = { { "<leader>a ", mode = "v" }, { "<leader>a=", mode = "v" }, { "<leader>a:", mode = "v" } },
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
    keys = {
      { "<C-x>", mode = "i" },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6", --recommended as each new version will have breaking changes
    opts = function()
      local default = require("ultimate-autopair.default").conf
      local internal_pairs = default.internal_pairs

      -- table.insert(internal_pairs, {
      --   "<", ">",
      --   fly = true,
      --   dosuround = true,
      --   newline = true,
      --   space = true,
      --   cond = function(fn)
      --     return not fn.in_node({ "arrow_function", "binary_expression", "augmented_assignment_expression" })
      --   end,
      -- })
      table.insert(internal_pairs, { "<div>", "</div>", fly = true, dosuround = true, newline = true, space = true })

      local configs = {
        fastwarp = { map = "<C-x>" },
        internal_pairs = internal_pairs,
      }
      return configs
    end,
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
      -- disable default keymaps
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

  -- { -- add symbols-outline
  --   "simrat39/symbols-outline.nvim",
  --   cmd = "SymbolsOutline",
  --   keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  --   config = true,
  -- },
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

  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    dependencies = {
      "theHamsta/nvim_rocks",
      build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
      config = function()
        require("nvim_rocks").ensure_installed("luautf8")
      end,
    },
    keys = {
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "E",
        "<cmd>lua require('spider').motion('E')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "W",
        "<cmd>lua require('spider').motion('W')<CR>",
        mode = { "n", "o", "x" },
      },
      -- ...
    },
  },
  -- { -- more useful text object
  --   "chaoren/vim-wordmotion",
  --   keys = {
  --     { "w", mode = { "n", "v" } },
  --     { "e", mode = { "n", "v" } },
  --     { "b", mode = { "n", "v" } },
  --     { "W", mode = { "n", "v" } },
  --     { "E", mode = { "n", "v" } },
  --     { "B", mode = { "n", "v" } },
  --   },
  -- },

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
      -- map("n", "gh", "<cmd>Neogit<cr>", { desc = "Open git tool interface" })
    end,
    keys = {
      { "gh", "<cmd>Neogit<cr>", desc = "Open git tool interface" },
    },
  },
}
