# Un-using plugins

```lua
{

  { -- add telescope-fzf-native
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      -- build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = "anuvyklack/middleclass",
    config = function()
      require("windows").setup()
    end,
  },
  {
    "nvim-focus/focus.nvim",
    version = "*",
    config = function()
      require("focus").setup({
        autoresize = {
          -- enable = true, -- Enable or disable auto-resizing of splits
          -- width = 20, -- Force width for the focused window
          -- height = 0, -- Force height for the focused window
          -- minwidth = 50, -- Force minimum width for the unfocused window
          -- minheight = 0, -- Force minimum height for the unfocused window
          -- height_quickfix = 10, -- Set the height of quickfix panel
        },
      })

      -- local ignore_filetypes = { "neo-tree" }
      local ignore_filetypes = { "neo-tree" }
      local ignore_buftypes = { "nofile", "prompt", "popup" }

      local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

      -- vim.api.nvim_create_autocmd("WinEnter", {
      --   group = augroup,
      --   callback = function(_)
      --     if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      --       vim.w.focus_disable = true
      --     else
      --       vim.w.focus_disable = false
      --     end
      --   end,
      --   desc = "Disable focus autoresize for BufType",
      -- })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for FileType",
      })
    end,
  },
  Resize Window
  {
    "camspiers/lens.vim",
    config = function()
      vim.cmd([[ let g:lens#animate = 0 ]])
    end,
  },
}
```
