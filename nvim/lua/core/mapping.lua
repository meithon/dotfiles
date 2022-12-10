local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

vim.g.mapleader = " "

local map = {
  -- Normal
  ["n|hk"] = map_cmd(":vsplit ~/dotfiles/nvim/hotkeys.md<CR>"):with_noremap(),
  ["n|x"] = map_cmd("\"_x"):with_noremap(),
  ["n|n"] = map_cmd("nzz"):with_noremap(),
  ["n|n"] = map_cmd("nzz"):with_noremap(),
  ["n|<C-h>"] = map_cmd(":%s//gI<Left><Left><Left>"),
  ["n|<Leader>F"] = map_cmd(":vimgrep // `git ls-files`<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>"),
  ["n|<CR>"] = map_cmd("i<CR><ESC>"):with_noremap(),
  ["n|<Leader>tsc"] = map_cmd(":set spell!"):with_noremap(),
  ["n|<C-w>"] = map_cmd(":tabnew<CR>"),


  -- Insert
  ["i|<C-f>"] = map_cmd("<Right>"):with_noremap(),
  ["i|<C-b>"] = map_cmd("<Left>"):with_noremap(),
  ["i|<C-n>"] = map_cmd("<Down>"):with_noremap(),
  ["i|<C-p>"] = map_cmd("<Up>"):with_noremap(),

  -- Command
  ["n|<C-f>"] = map_cmd("<Right>"):with_noremap(),
  ["n|<C-b>"] = map_cmd("<Left>"):with_noremap(),
  ["n|<C-n>"] = map_cmd("<Down>"):with_noremap(),
  ["n|<C-p>"] = map_cmd("<Up>"):with_noremap(),

  -- Visual
  ["v|<Leader>l"] = map_cmd("<ESC>"):with_noremap(),

  -- Terminal
  ["t|<ESC>"] = map_cmd("<C-\\><C-n>"):with_noremap(),
  ["t|<C-q>"] = map_cmd("<C-\\><C-n>:q<cr>"):with_noremap(),
  ["t|jk"] = map_cmd("<C-\\><C-n>"):with_noremap(),


}

bind.nvim_load_mapping(map)
