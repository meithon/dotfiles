return {
  {
    "davidosomething/format-ts-errors.nvim",
  },
  {

    "VidocqH/lsp-lens.nvim",
    config = function()
      require("lsp-lens").setup()
    end,
  },
  -- {
  -- 	"ray-x/navigator.lua",
  -- 	dependencies = {
  -- 		{ "ray-x/guihua.lua",     run = "cd lua/fzy && make" },
  -- 		{ "neovim/nvim-lspconfig" },
  -- 	},
  -- 	config = function()
  -- 		require("navigator").setup()
  -- 	end,
  -- },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "gr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    module = { "lspsaga.diagnostic" },
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function()
      require("lspsaga").setup({
        finder = {
          keys = {
            jump_to = "p",
            edit = { "i", "<CR>" },
            vsplit = "v",
            split = "s",
            tabe = "t",
            tabnew = "r",
            quit = { "q", "<ESC>" },
            close_in_preview = "<ESC>",
          },
        },
        symbol_in_winbar = { enable = false },
      })
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
    end,
    keys = {
      {
        "<Leader>cpa",
        function()
          require("actions-preview").code_actions()
        end,
        desc = "Code actions preview",
      },
    },
  },
  {
    "folke/neodev.nvim",
    config = true,
  },
  {
    "simrat39/rust-tools.nvim",
    filetypes = "rust",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      local rt = require("rust-tools")
      rt.setup()
      rt.inlay_hints.enable()
      -- rt.runnables.runnables()
      vim.api.nvim_create_user_command("RustRunnables", rt.runnables.runnables, {})
    end,
    command = {
      {
        "RustRunnables",
        function()
          require("rust-tools").runnables.runnables()
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "VimEnter",
    module = { "cmp" },
    dependencies = {
      { "onsails/lspkind.nvim", module = { "lspkind" } },
      { "lukas-reineke/cmp-under-comparator" },
      { "saadparwaiz1/cmp_luasnip" },
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      { "hrsh7th/cmp-nvim-lsp", module = { "cmp_nvimlsp" } },
      { "hrsh7th/cmp-nvim-lua" },
      { "andersevenrud/cmp-tmux" },
      { "hrsh7th/cmp-path" },
      { "f3fora/cmp-spell" },
      { "hrsh7th/cmp-buffer" },
      { "kdheepak/cmp-latex-symbols" },
      { "lukas-reineke/cmp-rg" },
      -- {
      -- 	"tzachar/cmp-tabnine",
      -- 	build = "./install.sh",
      -- 	config = function()
      -- 		require("cmp_tabnine.config").setup({
      -- 			max_lines = 1000,
      -- 			max_num_results = 20,
      -- 			sort = true,
      -- 			run_on_every_keystroke = true,
      -- 			snippet_placeholder = "..",
      -- 			ignored_file_types = {
      -- 				-- default is not to ignore
      -- 				-- uncomment to ignore in lua:
      -- 				-- lua = true
      -- 			},
      -- 			show_prediction_strength = false,
      -- 		})
      -- 		vim.api.nvim_create_autocmd("BufRead", {
      -- 			group = prefetch,
      -- 			pattern = "*.py",
      -- 			callback = function()
      -- 				require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
      -- 			end,
      -- 		})
      -- 	end,
      -- },
      {
        "zbirenbaum/copilot-cmp",
        config = true,
        dependencies = {
          {
            "zbirenbaum/copilot.lua",
            config = function()
              require("copilot").setup({
                suggestion = { enabled = true },
                panel = { enabled = false },
                fix_pairs = true,
              })
            end,
          },
        },
      },
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      luasnip.config.setup({
        region_check_events = "CursorHold,InsertLeave",
        delete_check_events = "TextChanged,InsertEnter",
      })

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      local compare = require("cmp.config.compare")
      compare.lsp_scores = function(entry1, entry2)
        local diff
        if entry1.completion_item.score and entry2.completion_item.score then
          diff = (entry2.completion_item.score * entry2.score)
            - (entry1.completion_item.score * entry1.score)
        else
          diff = entry2.score - entry1.score
        end
        return (diff < 0)
      end

      cmp.setup({
        performance = {
          debounce = 0,
          throttle = 0,
          fetching_timeout = 200,
        },
        completion = {
          completeopt = "menu,menuone", -- enable preselect
        },
        experimental = {
          ghost_text = true,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-e>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          {
            name = "copilot",
            -- keyword_length = 0,
            max_item_count = 3,
            group_index = 2,
          },
          { name = "nvim_lsp" },
          { name = "spell" },
          {
            name = "luasnip",
            option = { use_show_condition = false },
          },
          { name = "cmp_tabnine" },
          { name = "buffer" },
          { name = "path" },
          { name = "rg" },
          { name = "treesitter" },
        },
        formatting = {
          label = require("copilot_cmp.format").format_label_text,
          insert_text = require("copilot_cmp.format").format_insert_text,
          preview = require("copilot_cmp.format").deindent,
          format = function(entry, vim_item)
            local kind_icons = {
              Copilot = "",
              Text = "",
              Method = "",
              Function = "",
              Constructor = "",
              Field = "",
              Variable = "",
              Class = "ﴯ",
              Interface = "",
              Module = "",
              Property = "ﰠ",
              Unit = "",
              Value = "",
              Enum = "",
              Keyword = "",
              Snippet = "",
              Color = "",
              File = "",
              Reference = "",
              Folder = "",
              EnumMember = "",
              Constant = "",
              Struct = "",
              Event = "",
              Operator = "",
              TypeParameter = "",
            }
            -- From kind_icons array
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              vsnip = "[Snippet]",
              nvim_lua = "[Nvim Lua]",
              buffer = "[Buffer]",
              cmp_tabnine = "[TN]",
              spell = "[Spell]",
              luasnip = "[LuaSnip]",
            })[entry.source.name]

            return vim_item
          end,
        },
        sorting = {
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
        },
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "InsertEnter",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local globals = require("core.global")
      local formatter = globals.fotmatter
      local linter = globals.linter
      local code_action = globals.code_action
      local null_ls = require("null-ls")
      local null_sources = function()
        local source_return = {}

        -- set the formatters to null-ls
        for _, package in ipairs(formatter) do
          if package == "prettierd" then
            table.insert(
              source_return,
              null_ls.builtins.formatting.prettierd.with({
                filetypes = {
                  "html",
                  "javascript",
                  "javascriptreact",
                  "typescript",
                  "typescriptreact",
                  "vue",
                  "astro",
                  "svelte",
                },
              })
            )
            -- elseif package == "rustfmt" then
            -- 	table.insert(
            -- 		source_return,
            -- 		null_ls.builtins.formatting["rustfmt"].with({
            -- 			command = "cargo",
            -- 			arg = {
            -- 				"+nightly",
            -- 				"fmt",
            -- 				"--emit=stdout",
            -- 				"--all",
            -- 				"--",
            -- 				"--config=imports_granularity=Item,group_imports=StdExternalCrate",
            -- 			},
            -- 		})
            -- 	)
          else
            table.insert(source_return, null_ls.builtins.formatting[package])
          end
        end

        -- set the diagnostics to null-ls
        for _, package in ipairs(linter) do
          if package == "eslint_d" then
            table.insert(
              source_return,
              null_ls.builtins.diagnostics.eslint_d.with({
                filetypes = {
                  "javascript",
                  "javascriptreact",
                  "typescript",
                  "typescriptreact",
                  "vue",
                  "astro",
                  "svelte",
                },
              })
            )
          elseif package == "luacheck" then
            table.insert(
              source_return,
              null_ls.builtins.diagnostics.luacheck.with({
                std = "luajit",
                globals = { "vim" },
              })
            )
          elseif package == "cspell" then
            local cspell_config_dir = "~/.config/cspell"
            -- $XDG_DATA_HOME/cspell
            local cspell_data_dir = "~/.local/share/cspell"
            local cspell_files = {
              config = vim.call("expand", cspell_config_dir .. "/cspell.json"),
              dotfiles = vim.call("expand", cspell_config_dir .. "/dotfiles.txt"),
              vim = vim.call("expand", cspell_data_dir .. "/vim.txt.gz"),
              user = vim.call("expand", cspell_data_dir .. "/user.txt"),
            }
            -- vim辞書がなければダウンロード
            if vim.fn.filereadable("~/.local/share/cspell/vim.txt.gz") ~= 1 then
              local vim_dictionary_url =
                "https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz"
              io.popen(
                "curl -fsSLo " .. cspell_files.vim .. " --create-dirs " .. vim_dictionary_url
              )
            end
            -- CspellAppend
            local cspell_append = function(opts)
              local word = opts.args
              if not word or word == "" then
                -- 引数がなければcwordを取得
                word = vim.call("expand", "<cword>"):lower()
              end

              -- bangの有無で保存先を分岐
              local dictionary_name = opts.bang and "dotfiles" or "user"

              -- shellのechoコマンドで辞書ファイルに追記
              io.popen("echo " .. word .. " >> " .. cspell_files[dictionary_name])

              -- 追加した単語および辞書を表示
              vim.notify(
                '"' .. word .. '" is appended to ' .. dictionary_name .. " dictionary.",
                vim.log.levels.INFO,
                {}
              )

              -- cspellをリロードするため、現在行を更新してすぐ戻す
              if vim.api.nvim_get_option_value("modifiable", {}) then
                vim.api.nvim_set_current_line(vim.api.nvim_get_current_line())
                vim.api.nvim_command("silent! undo")
              end
            end

            vim.api.nvim_create_user_command(
              "CSpellAppend",
              cspell_append,
              { nargs = "?", bang = true }
            )

            -- ユーザー辞書がなければ作成
            if vim.fn.filereadable("~/.local/share/cspell/user.txt") ~= 1 then
              io.popen("mkdir -p " .. cspell_data_dir)
              io.popen("touch " .. cspell_files.user)
            end
            table.insert(
              source_return,
              null_ls.builtins.diagnostics.cspell.with({
                diagnostics_postprocess = function(diagnostic)
                  -- レベルをWARNに変更（デフォルトはERROR）
                  diagnostic.severity = vim.diagnostic.severity["WARN"]
                end,
                condition = function()
                  -- cspellが実行できるときのみ有効
                  return vim.fn.executable("cspell") > 0
                end,
                extra_args = {
                  "--config",
                  "~/.config/cspell/cspell.json",
                },
              })
            )
          else
            table.insert(source_return, null_ls.builtins.diagnostics[package])
          end
        end

        for _, package in ipairs(code_action) do
          table.insert(source_return, null_ls.builtins.code_actions[package])
        end
        return source_return
      end

      vim.api.nvim_create_user_command("LspFormat", function()
        vim.lsp.buf.format()
      end, {})
      -- if you want to set up formatting on save, you can use this as a callback
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        diagnostics_format = "#{m} (#{s}: #{c})",
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if "rust" ~= vim.api.nvim_buf_get_option(0, "filetype") then
                  vim.lsp.buf.format()
                end
              end,
            })
          end
        end,
        sources = null_sources(),
      })

      -- local null_helpers = require("null-ls.helpers")
      -- null_ls.register({
      -- 	name = "clippy",
      -- 	method = null_ls.methods.DIAGNOSTICS,
      -- 	filetypes = { "rust" },
      -- 	generator = null_ls.generator({
      -- 		command = "cargo",
      -- 		args = { "clippy", "--message-format", "short" },
      -- 		to_stdin = true,
      -- 		from_stderr = true,
      -- 		format = "line",
      -- 		on_output = null_helpers.diagnostics.from_pattern(
      -- 			[[:(%d+):(%d+): (%w*): (.*)]],
      -- 			{ "row", "col", "severity", "message" },
      -- 			-- , {
      -- 			-- 	pattern = [[(%w+): (%w*)]],
      -- 			-- 	groups = { "severity", "message" },
      -- 			{}
      -- 		),
      -- 	}),
      -- })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = "MasonToolsInstall",
    config = function()
      local globals = require("core.global")
      local formatter = globals.fotmatter
      local linters = globals.linter
      local lsps = globals.lsp

      local source = formatter
      for _, linter in ipairs(linters) do
        table.insert(source, linter)
      end
      for _, lsp in ipairs(lsps) do
        table.insert(source, lsp)
      end

      require("mason-tool-installer").setup({
        ensure_installed = source,
        auto_update = false,
        run_on_start = false,
        start_delay = 3000, -- 3 second delay
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = {
      { "neovim/nvim-lspconfig", module = "lspconfig" },
      { "ray-x/lsp_signature.nvim", module = "lsp_signature" },
    },
    config = function()
      require("mason-lspconfig").setup_handlers({
        function(server) -- default handler (optional)
          local opt = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              stylelintplus = {
                autoFixOnSave = true,
                autoFixOnFormat = true,
              },
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          }

          if server == "tsserver" then
            opt = {
              handlers = {
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
              },
            }
          end

          require("lspconfig")[server].setup(opt)
        end,
        require("lsp_signature").setup({
          hint_enable = false,
        }),
      })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },
}
