return {
  {
    "danilamihailov/beacon.nvim",
    config = function()
      vim.g.beacon_size = 120
      vim.g.beacon_timeout = 2000
      vim.g.beacon_fade_interval = 4
      vim.g.beacon_start_opacity = 40
      vim.cmd([[highlight Beacon guibg=#ff00b7 ctermbg=15]])
    end,
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
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "lilydjwg/colorizer",
    priority = 1,
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        messages = {
          enabled = false,
        },
        cmdline = {
          enabled = false,
        },
        lsp = {
          signature = {
            enabled = false,
          },
        },
      })
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
      })

      vim.notify = notify
    end,
  },
  {
    "gelguy/wilder.nvim",
    dependencies = {
      { "romgrk/fzy-lua-native", build = "make" },
    },
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })
      -- Disable Python remote plugin
      wilder.set_option("use_python_remote_plugin", 0)

      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline({
            fuzzy = 1,
            fuzzy_filter = wilder.lua_fzy_filter(),
          }),
          wilder.search_pipeline()
        ),
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer({
          highlighter = {
            wilder.lua_fzy_highlighter(), -- requires fzy-lua-native vim plugin found
            -- at https://github.com/romgrk/fzy-lua-native
          },
          highlights = {
            accent = wilder.make_hl("WilderAccent", "Pmenu", {
              { a = 1 },
              { a = 1 },
              { foreground = "#f4468f" },
            }),
          },
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
        })
      )
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      --vim.opt.listchars:append "space:⋅"
      vim.opt.listchars:append("eol:↴")

      vim.g.indent_blankline_filetype_exclude = { "startify" }
      require("indent_blankline").setup({
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      })
    end,
  },
  {
    "mhinz/vim-startify",
    config = function()
      vim.g.startify_padding_left = math.floor((vim.fn.winwidth(0) - 70) / 2)
      local ascii = {
        "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      }

      local center = vim.fn["startify#center"]
      vim.g.startify_custom_header = center(ascii)

      vim.g.startify_commands = {
        { t = "Neotree" },
        { g = "Git" },
        { d = "DockerToolsOpen" },
        { f = "Telescope find_files" },
        { s = "RestoreLastSession" },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = {
            {
              sources = { "nvim_diagnostic" },
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            "encoding",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "fugitive" },
      })
    end,
  },
  {
    "kdheepak/tabline.nvim",
    config = function()
      require("tabline").setup({
        options = {
          show_tabs_always = true,
          show_filename_only = true,
          modified_icon = "+ ",
        },
      })
      vim.cmd([[
      set guioptions-=e " Use showtabline in gui vim
      set sessionoptions+=tabpages,globals " store tabpages and globals in session
    ]])
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "theHamsta/tree-sitter-html",
      "David-Kunz/markid",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "p00f/nvim-ts-rainbow",
      "andymass/vim-matchup",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "json",
          "html",
          "javascript",
          "typescript",
          "lua",
          "astro",
          "go",
          "vim",
          "css",
          "scss",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
        context_commentstring = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["ic"] = "@class.inner",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
            },
          },
          dselect = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]["] = "@function.outer",
              ["]m"] = "@class.outer",
            },
            goto_next_end = {
              ["]]"] = "@function.outer",
              ["]M"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@function.outer",
              ["[m"] = "@class.outer",
            },
            goto_previous_end = {
              ["[]"] = "@function.outer",
              ["[M"] = "@class.outer",
            },
          },
        },
        autotag = {
          enable = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
        },
        markid = { enable = true },
        matchup = {
          enable = true,
        },
      })
    end,
  },
}
