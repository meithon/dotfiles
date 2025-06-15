-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Disable default keymaps
-- vim.keymap.del("n", "<C-h>")
-- vim.keymap.del("n", "<C-j>")
-- vim.keymap.del("n", "<C-k>")
-- vim.keymap.del("n", "<C-l>")

map({ "n", "v" }, "x", '"_x', { noremap = true })

map("n", "<CR>", "i<CR><ESC>", { noremap = true })
-- map("n", "<TAB>", "<C-^>", { noremap = true })
-- map("n", "<c-q>", "<cmd>q<cr>", { noremap = true })
map("n", "<D-s>", "<cmd>w<cr>", { noremap = true })
-- map("n", "<leader>w", "<cmd>w<cr>", { noremap = true })
-- map("n", "<leader>w", "<cmd>w<cr>", { noremap = true })
map("i", "<C-f>", "<Right>", { noremap = true })
map("i", "<C-b>", "<Left>", { noremap = true })
map("i", "<C-n>", "<Down>", { noremap = true })
map("i", "<C-p>", "<Up>", { noremap = true })
map("n", "<Right>", "<C-w>>20")
map("n", "<Left>", "<C-w><20")
map("n", "<Up>", "<C-w>+16")
map("n", "<Down>", "<C-w>-16")
map("n", "<C-p>", "<cmd>Telescope find_files<Cr>")
-- map("n", "<C-x>", "<cmd>quitall<Cr>")
-- map("n", "<C-q>", "<cmd>quit<Cr>")
map("n", "<D-.>", vim.lsp.buf.code_action)
map("n", "<D-s>", "<cmd>w<cr>", { noremap = true })
-- { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
--{
--   "<leader>cA",
--   function()
--     vim.lsp.buf.code_action({
--       context = {
--         only = {
--           "source",
--         },
--         diagnostics = {},
--       },
--     })
--   end,
--   desc = "Source Action",
--   has = "codeAction",
-- }
-- Terminal
map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
map("t", "<C-q>", "<C-:><C-n>:q<cr>", { noremap = true })
map(
  "n",
  "<leader>gd",
  "<cmd>Gitsigns toggle_deleted<CR><cmd>Gitsigns toggle_numhl<CR><cmd>Gitsigns toggle_linehl<cr>",
  { desc = "Show git diff" }
)
map("t", "<C-w>h", "<C-\\><C-n><C-w>h", { noremap = true })
map("t", "<C-w>j", "<C-\\><C-n><C-w>j", { noremap = true })
map("t", "<C-w>k", "<C-\\><C-n><C-w>k", { noremap = true })
map("t", "<C-w>l", "<C-\\><C-n><C-w>l", { noremap = true })

if not vim.g.vscode then
  return
end

local vscode = require('vscode')

local vscode_command = function(cmd)
  -- return map("<cmd>call VSCodeNotify('" .. cmd .. "')<cr>")
  return "<cmd>call VSCodeNotify('" .. cmd .. "')<cr>"
end

-- ////////////
-- // VSCode //
-- ////////////
-- map(
--   "n",
--   "<Leader>ff",
-- vscode_command("binocular.searchFile"),
-- )

--
-- -- edit
-- ["v|<C-n>"] = vscode_command("editor.action.addSelectionToNextFindMatch"),
-- -- buffer
-- ["n|<Leader><tab>"] = map_cr("call VSCodeNotify('workbench.action.quickOpen')"),
-- ["n|<C-W>q"] = map_cr("call VSCodeNotify('workbench.action.closeOtherEditors')"),
-- ["n|<Leader>e"] = map_cr("call VSCodeNotify('workbench.explorer.fileView.focus')"),
-- ["n|<Leader>tt"] = map_cr("call VSCodeNotify('workbench.action.terminal.focusAccessibleBuffer')"),
-- ["n|QQ"] = map_cr("call VSCodeNotify('workbench.action.closeActiveEditor')"),
--
-- -- Telescope
-- ["n|<leader>ff"] = vscode_command("binocular.searchFile"),
-- ["n|<Leader>fg"] = vscode_command_with_arg(
--   "BinocularFindGitFile",
--   "binocular.customCommands",
--   "find-git-file"
-- ),
-- ["n|<Leader><C-G>"] = vscode_command_with_arg(
--   "BinocularFindGitFile",
--   "binocular.customCommands",
--   "find-git-file"
-- ),

---- window
-- resize
map("n", "<C-W>y", vscode_command("workbench.action.increaseViewWidth"))
map("n", "<C-W>o", vscode_command("workbench.action.decreaseViewWidth"))
map("n", "<C-W>u", vscode_command("workbench.action.decreaseViewHeight"))
map("n", "<C-W>i", vscode_command("workbench.action.increaseViewHeight"))

-- diagnosti
map("n", "<Leader>ca", vscode_command("editor.action.sourceAction"))
map("n", "<Leader>n", vscode_command("editor.action.marker.next"))
map("n", "<Leader>p", vscode_command("editor.action.marker.prev"))
-- lsp
map("n", "gd", vscode_command("editor.action.revealDefinition"))
map("n", "gy", vscode_command("editor.action.goToTypeDefinition"))
map("n", "gr", vscode_command("editor.action.goToReferences"))
map("n", "gi", vscode_command("editor.action.goToImplementation"))
map("n", "<Leader>lr", vscode_command("editor.action.rename"))
map("n", "<Leader>gt", vscode_command(""))
map("n", "K", vscode_command("editor.action.showHover"))
map("n", "[d", vscode_command("editor.action.marker.prevInFiles"))
map("n", "]d", vscode_command("editor.action.marker.nextInFiles"))
map("n", "cr", vscode_command("editor.action.rename"))

-- move
-- move
local is_open = true
local function toggleFileView()
  if is_open then
    vscode.action("workbench.action.toggleSidebarVisibility")
    is_open = false
  else
    vscode.action("workbench.explorer.fileView.focus")
    is_open = true
  end
end
toggleFileView()
map("n", "<Leader>e", function()
  local vscode = require('vscode')
  toggleFileView()
end)

map("n", "<leader>bo", vscode_command("workbench.action.closeOtherEditors"))
map(
  "n",
  "<leader>bz",
  vscode_command("workbench.action.closeEditorsInOtherGroups")
    .. ";"
    .. vscode_command("workbench.action.closeOtherEditors")
)
---- git
--
map("n", "]g", vscode_command("workbench.action.editor.nextChange"))
map("n", "[g", vscode_command("workbench.action.editor.previousChange"))
map("n", "<leader>gs", vscode_command("workbench.view.scm"))

----test
map("n", "<leader>ts", vscode_command("workbench.view.testing.focus"))
map("n", "<leader>tr", vscode_command("testing.runAtCursor"))
-- ["n|gd"] = map_cr("call VSCodeNotify('editor.action.revealDefinition')"),
-- ["n|gr"] = map_cr("call VSCodeNotify('editor.action.goToReferences')"),
-- ["n|gi"] = map_cr("call VSCodeNotify('editor.action.goToImplementation')"),
-- ["n|<Leader>lr"] = map_cr("call VSCodeNotify('editor.action.rename')"),
-- ["n|<Leader>gt"] = map_cmd("call VSCodeNotify('')"),

-- git
-- ["n|<Leader>gs"] = map_cr("call VSCodeNotify(binocular.customCommands)"),
-- ["n|<Leader>gs"] = vscode_command_with_arg("BinocularGit", "binocular.customCommands", "Lazygit"),
-- ["n|gj"] = map_cr("call VSCodeNotify('workbench.action.editor.nextChange')"),
-- ["n|gk"] = map_cr("call VSCodeNotify('workbench.action.editor.previousChange')"),
-- ["v|<Leader>ga"] = vscode_range_command("GitAdd", "git.stageSelectedRanges"),
-- ["v|<Leader>gr"] = vscode_range_command("GitReset", "git.unstageSelectedRanges"),
-- ["n|<Leader>gd"] = vscode_range_command("GitDiff", "git.openChange"),
-- ["n|<Leader>gh"] = vscode_range_command("GitDiff", "git.openChange"),
-- ["n|K"] = map_cr("call VSCodeNotify('editor.action.showHover')"),


vim.keymap.set({ "n", "x", "i" }, "<C-n>", function()
  vscode.with_insert(function()
    vscode.action("editor.action.addSelectionToNextFindMatch")
  end)
end)
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function()
        local mode = vim.api.nvim_get_mode().mode
        if mode == "i" then
            require('vscode').action("neovim-ui-indicator.insert")
        elseif mode == "v" then
            require('vscode').action("neovim-ui-indicator.visual")
        elseif mode == "n" then
            require('vscode').action("neovim-ui-indicator.normal")
        end
    end,
})
require('vscode').action("neovim-ui-indicator.cursorCenter")