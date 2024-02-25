-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end

vim.g.neovide_transparency = 0.7
vim.g.transparency = 0.3
-- vim.g.neovide_background_color = "#0f1117" .. alpha()
vim.g.neovide_window_blurred = true
vim.g.neovide_scroll_animation_length = 0.03

vim.g.neovide_touch_drag_timeout = 0.17

vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_animation_length = 0.02
-- vim.g.neovide_floating_blur_amount_x = 2.3
--
-- vim.g.neovide_floating_blur_amount_y = 2.3
