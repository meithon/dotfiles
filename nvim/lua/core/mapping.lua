local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

vim.g.mapleader = " "

local map = {
  ["n|x"] = map_cmd("\"_x"):with_noremap(),
}

bind.nvim_load_mapping(map)
