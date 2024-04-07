local map = vim.keymap.set

---@alias Plugins plugins.Plugin[]
---@type Plugins
return {
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
  {
    {
      "sourcegraph/sg.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
      },
    },
  },
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
  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      alpha = 0.8, -- amount of dimming
    },
    keys = { { "<leader>uh", "<cmd>Twilight<cr>", desc = "Highlight code" } },
  },
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
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- getenv
      storage = {
        home = os.getenv("HOME") .. "/workspace/leetcode",
      },
      -- configuration goes here
      lang = "typescript",
    },
  },
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
      -- map("n", "gh", "<cmd>Neogit<cr>", { desc = "Open git tool interface" })
    end,
    keys = {
      { "gh", "<cmd>Neogit<cr>", desc = "Open git tool interface" },
    },
  },
}
