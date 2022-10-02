require 'hop'.setup()

vim.api.nvim_set_keymap('', 's', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, hint_offset = 0 })<cr>",
    {})
vim.api.nvim_set_keymap('', '<leader>s', "<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>", {})
