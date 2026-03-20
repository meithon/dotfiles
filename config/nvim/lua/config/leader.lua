local map = vim.keymap.set

local function nmap(key, icmd)
  local cmd = "<cmd>" .. icmd .. "<cr>"
  map("n", key, cmd, { noremap = true, nowait = true })
end

nmap("<space>e", "Neotree toggle")
nmap("<space>r", "Lspsaga finder")
nmap("<space>k", "Gitsigns prev_hunk")
nmap("<space>j", "Gitsigns next_hunk")

--
map("n", "<space>s", function()
  require("gitsigns.actions").stage_hunk()
end, { noremap = true, silent = true, nowait = true })

map("n", "<space>S", function()
  require("gitsigns.actions").stage_hunk()
end, { noremap = true, silent = true, nowait = true })

-- unstage
map("n", "<space>u", function()
  require("gitsigns.actions").reset_hunk()
end, { noremap = true, silent = true })

-- map("n", "<space>h", "0", { noremap = true, silent = true })
-- map("n", "<space>l", "$", { noremap = true, silent = true, nowait = true })
nmap("<space>h", "TSWJumpToStartOfMasterNode")
nmap("<space>l", "TSWJumpToEndOfMasterNode")
nmap("<space>l", "TSWJumpToEndOfMasterNode")

vim.keymap.set({ "x", "o" }, "vi", "<Cmd>TSWSelectCurrentNode<CR>", { silent = true })
vim.keymap.set({ "x", "o" }, "va", "<Cmd>TSWSelectMasterNode<CR>", { silent = true })

nmap("<space>g", "Telescope git_status")
nmap("<space>f", "Telescope find_files")

nmap("<space>Q", "BDelete! this")
nmap("<space>bo", "BDelete! hidden")

nmap("<space>o", "Outline")

nmap("<space>d", "Gitsigns toggle_deleted<CR><cmd>Gitsigns toggle_numhl<CR><cmd>Gitsigns toggle_linehl")
nmap("<space>a", "CodeCompanionChat")
