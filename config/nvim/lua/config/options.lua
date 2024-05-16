-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local alpha = function()
  return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
end

vim.g.neovide_transparency = 0.8
vim.g.transparency = 0.3
-- vim.g.neovide_background_color = "#0f1117" .. alpha()
vim.g.neovide_window_blurred = true
vim.g.neovide_scroll_animation_length = 0.03

vim.g.neovide_touch_drag_timeout = 0.17

vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_animation_length = 0.02
vim.g.neovide_input_ime = true
-- vim.g.neovide_floating_blur_amount_x = 2.3
--
-- vim.g.neovide_floating_blur_amount_y = 2.3
--
vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end)

if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  vim.defer_fn(function()
    vim.cmd("NeovideFocus")
  end, 100)
end

--
-- -- * a function with signature `function(buf) -> string|string[]`
-- vim.g.root_spec = {}
