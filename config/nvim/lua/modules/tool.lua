return {
  {
    "IndianBoy42/tree-sitter-just",
    config = function()
      require("nvim-treesitter.parsers").get_parser_configs().just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
        },
        maintainers = { "@IndianBoy42" },
      }
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
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
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "kkharji/sqlite.lua", module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup({
        history = 100,
        enable_persistent_history = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        keys = {
          telescope = {
            i = {
              paste = "<cr>",
            },
            n = {
              paste = "<cr>",
            },
          },
          fzf = {
            paste = "<cr>",
          },
        },
      })

      vim.api.nvim_create_user_command("Neoclip", function()
        -- require("telescope.builtin").find_files(require("telescope.themes").get_dropdown)
        require("telescope").extensions.neoclip.default(require("telescope.themes").get_cursor({

          layout_config = {
            width = 180,
            height = 30,
          },
          -- width = 0.9,
          -- winblend = 30,
        }))
      end, {})
      require("telescope").load_extension("neoclip")
    end,
    cmd = {
      "Telescope neoclip",
      "Neoclip",
    },
    keys = {
      {
        [["]],
        ":Neoclip<CR>",
        desc = "Fzf search registry",
        mode = { "n", "v" },
      },
      { [[y]], mode = { "n", "v" } },
    },
  },
  {
    "voldikss/vim-translator",
    config = function()
      vim.g.translator_target_lang = "ja"
    end,
  },
  {
    "aduros/ai.vim",
  },
  -- {
  --   name = "mover.nvim",
  --   dir = "~/workspace/mover.nvim//",
  --   dev = true,
  --   lazy = false,
  --   config = function()
  --     require("mover").setup()
  --   end,
  -- },
  -- {
  --   name = "say-hello.nvim",
  --   dir = "~/workspace/say-hello.nvim//",
  --   dev = true,
  --   lazy = false,
  --   config = function()
  --     require("say-hello").setup()
  --   end,
  -- },
  {
    -- HIstory of curtsor position
    "cbochs/portal.nvim",
    -- Optional dependencies
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
    config = function()
      require("portal").setup({
        escape = {
          ["<esc>"] = true,
          ["q"] = true,
          ["<C-i>"] = true,
          ["<C-o>"] = true,
        },
        labels = { "a", "s", "d", "f", "g" },
        window_options = {
          relative = "cursor",
          width = 80,
          height = 8,
          col = 5,
          focusable = false,
          border = "single",
          noautocmd = true,
        },
      })
    end,
  },
  {
    "mrjones2014/legendary.nvim",
    config = function()
      require("legendary").setup()
    end,
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = true,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })

      vim.cmd([[command Rest lua require"rest-nvim".run()]])
      vim.cmd([[command RestPreview lua require"rest-nvim".run(true)]])
      vim.cmd([[command RestLast lua require"rest-nvim".last()]])
    end,
  },
  {
    "bayne/vim-dot-http",
    lazy = true,
    ft = "http",
    cmd = "DotHttp",
    config = function()
      vim.g.dot_http_env = "dev"
    end,
  },
  {
    "numToStr/FTerm.nvim",
    lazy = true,
    cmd = { "FTermOpen", "FTermClose", "FTermClose" },
    config = function()
      require("FTerm").setup({
        border = "double",
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })

      -- create command
      vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
      vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
      vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "InsertLeave",
    config = function()
      require("which-key").setup({
        key_labels = {
          ["<space>"] = "<SPACE>",
          ["<CR>"] = "<ENTER>",
          ["<Tab>"] = "<TAB>",
        },
        triggers = { "<leader>" }, -- If not written, conflict with vfiler to cause error occurs
        disable = {
          buftypes = { "vfiler", "nofile" },
          filetypes = { "vfiler", "nofile" },
        },
      })
    end,
  },
  {
    "kkvh/vim-docker-tools",
    cmd = "DockerToolsOpen",
  },
  {
    "thinca/vim-qfreplace",
    event = "QuickFixCmdPost",
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = {
            "┃",
            "┃",
            "━",
            "━",
            "┏",
            "┓",
            "┗",
            "┛",
            "█",
          },
          show_title = false,
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
              -- skip file size greater than 100k
              ret = false
            elseif bufname:match("^fugitive://") then
              -- skip fugitive buffer
              ret = false
            end
            return ret
          end,
        },
        -- make `drop` and `tab drop` to become preferred
        func_map = {
          drop = "o",
          openc = "O",
          split = "<C-s>",
          tabdrop = "<C-t>",
          -- set to empty string to disable
          tabc = "",
          ptogglemode = "z,",
        },
        filter = {
          fzf = {
            action_for = {
              ["ctrl-s"] = "split",
              ["ctrl-t"] = "tab drop",
            },
            extra_opts = {
              "--bind",
              "ctrl-o:toggle-all",
              "--prompt",
              "> ",
            },
          },
        },
      })
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick" },
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
  {
    "tpope/vim-fugitive",
    cmd = { "GV", "Git", "Gdiffsplit", "Gvdiffsplit" },
  },
  {
    "junegunn/gv.vim",
    cmd = { "GV" },
  },
  {
    "mbbill/undotree",
    cmd = { "UndotreeShow", "UndotreeFocus" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "./.git/", "node_modules/" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
    keys = {
      {
        "<leader>ff",
        ":Telescope find_files<CR>",
        desc = "Find files",
        mode = { "n" },
      },
    },
  },
  {
    "princejoogie/dir-telescope.nvim",
    -- telescope.nvim is a required dependency
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dir-telescope").setup({
        -- these are the default options set
        hidden = true,
        no_ignore = false,
        show_preview = true,
      })
      require("telescope").load_extension("dir")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = { "Neotree" },
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        tag = "v1.5",
        config = function()
          require("window-picker").setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options

              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = {
                  "neo-tree",
                  "neo-tree-popup",
                  "notify",
                },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            other_win_hl_color = "#e35e4f",
          })
        end,
      },
    },
    config = function()
      local function getTelescopeOpts(state, path)
        return {
          cwd = path,
          search_dirs = { path },
          attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local selection = action_state.get_selected_entry()
              local filename = selection.filename
              if filename == nil then
                filename = selection[1]
              end
              -- any way to open the file without triggering auto-close event of neo-tree?
              require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
            end)
            return true
          end,
        }
      end
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
      -- NOTE: this is changed from v1.x, which used the old style of highlight groups
      -- in the form "LspDiagnosticsSignWarning"

      local commands = require("neo-tree.sources.filesystem.commands")
      require("neo-tree").setup({
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            -- highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            -- expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<2-LeftMouse>"] = "open",
            -- ["<cr>"] = "open",
            ["<cr>"] = function(state)
              local node = state.tree:get_node()
              if node.type == "directory" then
                commands.open(state)
                commands.set_root(state)
              else
                commands.open_with_window_picker(state)
              end
            end,
            ["<esc>"] = "revert_preview",
            ["P"] = {
              "toggle_preview",
              config = { use_float = true },
            },
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["h"] = function(state)
              local node = state.tree:get_node()
              if node.type == "directory" and node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
              end
            end,
            ["l"] = function(state)
              local node = state.tree:get_node()
              if node.type == "directory" then
                if not node:is_expanded() then
                  require("neo-tree.sources.filesystem").toggle_directory(state, node)
                elseif node:has_children() then
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              end
            end,
            ["H"] = "close_all_nodes",
            ["L"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none", -- "none", "relative", "absolute"
              },
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["m"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            -- ["o"] = "fuzzy_sorter",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          },
        },
        nesting_rules = {},
        filesystem = {
          find_by_full_path_words = true,

          commands = {
            telescope_find = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              require("telescope.builtin").find_files(getTelescopeOpts(state, path))
            end,
            telescope_grep = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
            end,
            open_and_clear_filter = function(state)
              local node = state.tree:get_node()
              if node and node.type == "file" then
                local file_path = node:get_id()
                -- reuse built-in commands to open and clear filter
                local cmds = require("neo-tree.sources.filesystem.commands")
                cmds.open(state)
                cmds.clear_filter(state)
                -- reveal the selected file without focusing the tree
                require("neo-tree.sources.filesystem").navigate(state, state.path, file_path)
              end
            end,
            fuzzy_sorter = function(state)
              local filter = require("neo-tree.sources.filesystem.lib.filter")
              filter.show_filter(state, true, true, true)
            end,
          },
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
              ".git",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = false, -- This will find and focus the file in the active buffer every
          -- time the current file is changed while the tree is open.
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- in whatever position is specified in window.position
          -- "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              -- ["H"] = "set_root",
              ["."] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["o"] = "fuzzy_sorter",
              ["D"] = "fuzzy_finder_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["gk"] = "prev_git_modified",
              ["gj"] = "next_git_modified",
              --["tf"] = "telescope_find",
              --["tg"] = "telescope_grep",
              -- ["o"] = "open_and_clear_filter",
            },
          },
        },
        buffers = {
          follow_current_file = true, -- This will find and focus the file in the active buffer every
          -- time the current file is changed while the tree is open.
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              -- ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["gs"] = "git_stage_file",
              -- ["ga"] = "git_add_file",
              -- ["gr"] = "git_revert_file",
              -- ["gc"] = "git_commit",
              -- ["gp"] = "git_push",
              -- ["gg"] = "git_commit_and_push",
            },
          },
        },
      })
    end,
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons", -- optional, for file icons
  --   },
  --   -- cmd = { "NvimTreeOpen", "NvimTreeToggle" },
  --   config = function()
  --     function find_directory_and_focus()
  --       local actions = require("telescope.actions")
  --       local action_state = require("telescope.actions.state")
  --
  --       local function open_nvim_tree(prompt_bufnr, _)
  --         actions.select_default:replace(function()
  --           local api = require("nvim-tree.api")
  --
  --           actions.close(prompt_bufnr)
  --           local selection = action_state.get_selected_entry()
  --           api.tree.open()
  --           api.tree.find_file(selection.cwd .. "/" .. selection.value)
  --         end)
  --         return true
  --       end
  --
  --       require("telescope.builtin").find_files({
  --         find_command = {
  --           "fd",
  --           "--type",
  --           "directory",
  --           "--hidden",
  --           "--exclude",
  --           ".git/*",
  --         },
  --         attach_mappings = open_nvim_tree,
  --       })
  --     end
  --
  --     vim.keymap.set("n", "fd", find_directory_and_focus)
  --
  --     local api = require("nvim-tree.api")
  --     local openfile = require("nvim-tree.actions.node.open-file")
  --     local actions = require("telescope.actions")
  --     local action_state = require("telescope.actions.state")
  --     local treeutils = {}
  --
  --     local view_selection = function(prompt_bufnr, map)
  --       actions.select_default:replace(function()
  --         actions.close(prompt_bufnr)
  --         local selection = action_state.get_selected_entry()
  --         local filename = selection.filename
  --         if filename == nil then
  --           filename = selection[1]
  --         end
  --         openfile.fn("preview", filename)
  --       end)
  --       return true
  --     end
  --
  --     function treeutils.launch_live_grep(opts)
  --       return treeutils.launch_telescope("live_grep", opts)
  --     end
  --
  --     function treeutils.launch_find_files(opts)
  --       return treeutils.launch_telescope("find_files", opts)
  --     end
  --
  --     function treeutils.launch_telescope(func_name, opts)
  --       local telescope_status_ok, _ = pcall(require, "telescope")
  --       if not telescope_status_ok then
  --         return
  --       end
  --       local node = api.tree.get_node_under_cursor()
  --       local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
  --       local basedir = is_folder and node.absolute_path
  --         or vim.fn.fnamemodify(node.absolute_path, ":h")
  --       if node.name == ".." and TreeExplorer ~= nil then
  --         basedir = TreeExplorer.cwd
  --       end
  --       opts = opts or {}
  --       opts.cwd = basedir
  --       opts.search_dirs = { basedir }
  --       opts.attach_mappings = view_selection
  --       return require("telescope.builtin")[func_name](opts)
  --     end
  --
  --     vim.keymap.set("n", "<c-f>", treeutils.launch_find_files, {})
  --     vim.keymap.set("n", "<c-g>", treeutils.launch_live_grep, {})
  --
  --     local lib = require("nvim-tree.lib")
  --     local view = require("nvim-tree.view")
  --     local api = require("nvim-tree.api")
  --
  --     local function collapse_all()
  --       require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
  --     end
  --
  --     local function edit_or_open()
  --       -- open as vsplit on current node
  --       local action = "edit"
  --       local node = lib.get_node_at_cursor()
  --
  --       -- Just copy what's done normally with vsplit
  --       if node.link_to and not node.nodes then
  --         require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
  --       elseif node.nodes ~= nil then
  --         lib.expand_or_collapse(node)
  --       else
  --         require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
  --       end
  --     end
  --
  --     local function vsplit_preview()
  --       -- open as vsplit on current node
  --       local action = "vsplit"
  --       local node = lib.get_node_at_cursor()
  --
  --       -- Just copy what's done normally with vsplit
  --       if node.link_to and not node.nodes then
  --         require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
  --       elseif node.nodes ~= nil then
  --         lib.expand_or_collapse(node)
  --       else
  --         require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
  --       end
  --
  --       -- Finally refocus on tree if it was lost
  --       view.focus()
  --     end
  --
  --     local function edit_or_cd()
  --       -- open as vsplit on current node
  --       local action = "edit"
  --       local node = lib.get_node_at_cursor()
  --
  --       -- Just copy what's done normally with vsplit
  --       if node.link_to and not node.nodes then
  --         require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
  --       elseif node.nodes ~= nil then
  --         api.tree.change_root_to_node(node)
  --       else
  --         require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
  --       end
  --     end
  --     require("nvim-tree").setup({
  --       view = {
  --         mappings = {
  --           custom_only = false,
  --           list = {
  --             {
  --               key = "l",
  --               action = "edit",
  --               action_cb = edit_or_open,
  --             },
  --             {
  --               key = "L",
  --               action = "vsplit_preview",
  --               action_cb = vsplit_preview,
  --             },
  --             { key = "h", action = "close_node" },
  --             {
  --               key = "H",
  --               action = "collapse_all_subnodes",
  --               action_cb = collapse_all,
  --             },
  --             {
  --               key = "<CR>",
  --               action = "cd",
  --               action_cb = edit_or_cd,
  --             },
  --             { key = "<BS>", action = "dir_up" },
  --             { key = "v", action = "vsplit" },
  --             { key = "s", action = "split" },
  --           },
  --         },
  --       },
  --       actions = {
  --         open_file = {
  --           quit_on_open = false,
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "obaland/vfiler.vim",

    cmd = "VFiler",
    dependencies = {
      "obaland/vfiler-column-devicons",
    },
    config = function()
      require("vfiler/config").setup({
        options = {
          columns = "indent,devicons,name,git",
          auto_cd = true,
          auto_resize = true,
          keep = true,
          layout = "left",
          width = 40,
          git = {
            enabled = true,
            untracked = true,
            ignored = true,
          },
        },
      })
    end,
  },
}
