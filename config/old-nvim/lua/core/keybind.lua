local lsp = {
  goto_definition = "gd",
  goto_implmentation = "gi",
  goto_type_definition = "gy",
  lsp_finder = "gh",

  code_action = "<leader>ca",
  hover_doc = "K",

  -- diagnostics
  prev_diagnostic = "<leader>p",
  next_diagnostic = "<leader>n",
  show_diagnostic = "<leader>lt",

  -- find
  find_lsp_symbol = "<leader>ls",
}
local editor = {
  -- window
  ---- move
  move_left = "<C-w>h",
  move_down = "<C-w>j",
  move_up = "<C-w>k",
  move_right = "<C-w>l",

  ---- resize
  resize_left = "<C-w>y",
  resize_down = "<C-w>u",
  resize_up = "<C-w>i",

  resize_right = "<C-w>o",

  -- fold
  fold_open = "zf",
  fold_close = "<s_tab>",

  -- git
  stage_hunk = "<leader>ga",
  unstage_hunk = "<leader>gu",
  reset_hunk = "<leader>gr",
  prev_hunk = "gk",
  next_hunk = "gj",

  multi_cursor = "<C-n>",
}
local tool = {}
local ui = {}

local M = {
  lsp,
  editor = editor,
  tool,
  ui,
}

return M
