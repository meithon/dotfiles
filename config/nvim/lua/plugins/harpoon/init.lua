---@type plugins.PluginSpec[]
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local ok, harpoon = pcall(require, "harpoon")
      if not ok then
        return
      end

      harpoon:setup()

      vim.api.nvim_create_user_command("HarpoonAdd", function()
        harpoon:list():add()
      end, { desc = "Harpoon v2: add current file" })

      vim.api.nvim_create_user_command("HarpoonMenu", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon v2: toggle quick menu" })

      vim.api.nvim_create_user_command("HarpoonNext", function()
        harpoon:list():next()
      end, { desc = "Harpoon v2: go to next item" })

      vim.api.nvim_create_user_command("HarpoonPrev", function()
        harpoon:list():prev()
      end, { desc = "Harpoon v2: go to previous item" })

      vim.api.nvim_create_user_command("HarpoonRemove", function()
        harpoon:list():remove()
      end, { desc = "Harpoon remove current item" })

      vim.api.nvim_create_user_command("HarpoonGo", function(opts)
        local idx = tonumber(opts.args)
        if not idx then
          vim.notify("HarpoonGo requires a numeric index", vim.log.levels.ERROR)
          return
        end
        harpoon:list():select(idx)
      end, {
        nargs = 1,
        desc = "Harpoon v2: jump to item by index",
        complete = function()
          return { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
        end,
      })

      harpoon:extend({
        UI_CREATE = function(cx)
          local menu_actions = {}

          local function to_help_line(action)
            local label = action.label or (action.desc and action.desc:gsub("^Harpoon%s+", "")) or ""
            return string.format("%-6s: %s", action.lhs, label)
          end

          local function show_help_panel()
            local lines = { "Harpoon Menu Help", "" }
            for _, action in ipairs(menu_actions) do
              table.insert(lines, to_help_line(action))
            end

            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].bufhidden = "wipe"
            vim.bo[buf].modifiable = false

            local width = 42
            local height = #lines
            local row = math.floor((vim.o.lines - height) / 2 - 1)
            local col = math.floor((vim.o.columns - width) / 2)

            local win = vim.api.nvim_open_win(buf, true, {
              relative = "editor",
              row = math.max(row, 0),
              col = math.max(col, 0),
              width = width,
              height = height,
              style = "minimal",
              border = "rounded",
              title = " Harpoon ",
              title_pos = "center",
            })

            vim.keymap.set("n", "q", function()
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
              end
            end, { buffer = buf, nowait = true, silent = true })
            vim.keymap.set("n", "<Esc>", function()
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
              end
            end, { buffer = buf, nowait = true, silent = true })
          end

          local function redraw_and_focus(row)
            local list = harpoon:list()
            vim.api.nvim_buf_set_lines(cx.bufnr, 0, -1, false, list:display())
            local length = list:length()
            if length < 1 then
              return
            end
            local target = math.max(1, math.min(row, length))
            vim.api.nvim_win_set_cursor(cx.win_id, { target, 0 })
          end

          local function move_harpoon_item(delta)
            local list = harpoon:list()
            local row = vim.api.nvim_win_get_cursor(cx.win_id)[1]
            local target = row + delta
            local length = list:length()
            if target < 1 or target > length then
              return
            end

            local current_item = list:get(row)
            local target_item = list:get(target)
            list:replace_at(target, current_item)
            list:replace_at(row, target_item)
            redraw_and_focus(target)
          end

          menu_actions = {
            {
              lhs = "<C-j>",
              desc = "Harpoon move item down",
              rhs = function()
                move_harpoon_item(1)
              end,
            },
            {
              lhs = "<C-k>",
              desc = "Harpoon move item up",
              rhs = function()
                move_harpoon_item(-1)
              end,
            },
            {
              lhs = "a",
              desc = "Harpoon add current file",
              rhs = function()
                local path = cx.current_file
                if path == nil or path == "" then
                  return
                end
                harpoon:list():add({ value = path, context = {} })
                redraw_and_focus(harpoon:list():length())
              end,
            },
            {
              lhs = "v",
              desc = "Harpoon open in vertical split",
              rhs = function()
                harpoon.ui:select_menu_item({ vsplit = true })
              end,
            },
            {
              lhs = "t",
              desc = "Harpoon open in tab",
              rhs = function()
                harpoon.ui:select_menu_item({ tabedit = true })
              end,
            },
            {
              lhs = "x",
              desc = "Harpoon remove item under cursor",
              rhs = function()
                local row = vim.api.nvim_win_get_cursor(cx.win_id)[1]
                harpoon:list():remove_at(row)
                redraw_and_focus(row)
              end,
            },
            {
              lhs = "<C-x>",
              desc = "Harpoon remove and compact list",
              rhs = function()
                local list = harpoon:list()
                local row = vim.api.nvim_win_get_cursor(cx.win_id)[1]
                local kept = {}
                for i = 1, list:length() do
                  if i ~= row then
                    local item = list:get(i)
                    if item ~= nil then
                      table.insert(kept, item)
                    end
                  end
                end
                list:clear()
                for _, item in ipairs(kept) do
                  list:add(item)
                end
                redraw_and_focus(row)
              end,
            },
            {
              lhs = "?",
              desc = "Harpoon help",
              rhs = show_help_panel,
            },
            { lhs = "<CR>", desc = "Harpoon open" },
            { lhs = "q/<Esc>", desc = "Harpoon close menu" },
          }

          for _, action in ipairs(menu_actions) do
            if action.rhs then
              vim.keymap.set("n", action.lhs, action.rhs, { buffer = cx.bufnr, desc = action.desc })
            end
          end
        end,
      })

      local harpoon_extensions = require("harpoon.extensions")
      harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    end,
    cmd = {
      "HarpoonAdd",
      "HarpoonMenu",
      "HarpoonNext",
      "HarpoonPrev",
      "HarpoonGo",
      "HarpoonRemove",
    },
  },
}
