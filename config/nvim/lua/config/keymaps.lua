-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map({ "n", "v" }, "x", '"_x', { noremap = true })

map("n", "<CR>", "i<CR><ESC>", { noremap = true })

map("i", "<C-f>", "<Right>", { noremap = true })
map("i", "<C-b>", "<Left>", { noremap = true })
map("i", "<C-n>", "<Down>", { noremap = true })
map("i", "<C-p>", "<Up>", { noremap = true })

-- Terminal
map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
map("t", "<C-q>", "<C-:><C-n>:q<cr>", { noremap = true })
map(
  "n",
  "gh",
  "<cmd>Gitsigns toggle_deleted<CR>:Gitsigns toggle_numhl<CR>:Gitsigns toggle_linehl<cr>",
  { desc = "Show git diff" }
)
