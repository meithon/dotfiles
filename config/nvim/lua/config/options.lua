-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local alpha = function()
  return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
end

local opt = vim.opt
opt.splitkeep = "cursor"
vim.cmd("set nospell")

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

-- swapfile

-- swapファイルの更新間隔を短くする（ミリ秒単位）
-- vim.opt.updatetime = 100 -- デフォルトは4000
--
-- -- swapファイルの保存先を指定
-- vim.opt.directory = vim.fn.stdpath("data") .. "/swap//"
--
-- -- swapファイル作成を確実に有効化
-- vim.opt.swapfile = true
--
-- -- バックアップも有効化（オプション）
-- vim.opt.backup = true
-- vim.opt.writebackup = true
--
-- -- swapファイルの自動クリーンアップ設定
-- vim.api.nvim_create_autocmd("VimLeave", {
--   pattern = "*",
--   callback = function()
--     -- swapディレクトリのパスを取得
--     local swap_dir = vim.fn.stdpath("data") .. "/swap"
--
--     -- 古いswapファイルを検索して削除（7日以上前のファイル）
--     local cmd = string.format('find "%s" -type f -mtime +7 -delete', swap_dir)
--     vim.fn.system(cmd)
--   end,
-- })

-- 起動時に無効なswapファイルをクリーンアップ
-- vim.api.nvim_create_autocmd("VimEnter", {
--   pattern = "*",
--   callback = function()
--     -- 存在しないバッファのswapファイルを削除
--     for _, swapfile in ipairs(vim.fn.glob(vim.fn.stdpath('data') .. '/swap/*', true, true)) do
--       local swapname = vim.fn.fnamemodify(swapfile, ':t')
--       if not vim.fn.filereadable(swapname) then
--         vim.fn.delete(swapfile)
--       end
--     end
--   end
-- })
