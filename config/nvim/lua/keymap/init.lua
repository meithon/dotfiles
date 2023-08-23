local bind = require("keymap.bind")
local map_cmd = bind.map_cmd
local globals = require("core.global")

local map = {
  -- persistence *Settion manager
  ["n|<leader>qs"] = map_cmd([[:lua require("persistence").load()<CR>]]),
  ["n|<leader>ql"] = map_cmd([[:lua require("persistence").load({ last = true })<CR>]]),
  ["n|<leader>qd"] = map_cmd([[:lua require("persistence").stop()<CR>]]),
  --Portal
  ["n|<C-o>"] = map_cmd(":Portal jumplist backward<cr>"):with_noremap():with_silent(),
  ["n|<C-i>"] = map_cmd(":Portal jumplist forward<cr>"):with_noremap():with_silent(),
  --Tabline
  ["n|<C-w>r"] = map_cmd(":TablineTabRename "):with_noremap():with_silent(),
  -- Close-buffers
  ["n|<C-w>q"] = map_cmd(":BDelete! hidden<CR>"):with_noremap():with_silent(),
  -- sandwich
  -- -- add
  ["n|sa"] = map_cmd("<Plug>(sandwich-add)"):with_noremap():with_silent(),
  ["x|sa"] = map_cmd("<Plug>(sandwich-add)"):with_noremap():with_silent(),
  ["o|sa"] = map_cmd("<Plug>(sandwich-add)"):with_noremap():with_silent(),
  -- -- delete
  ["n|sd"] = map_cmd("<Plug>(sandwich-delete)"):with_noremap():with_silent(),
  ["x|sd"] = map_cmd("<Plug>(sandwich-delete)"):with_noremap():with_silent(),
  ["o|sd"] = map_cmd("<Plug>(sandwich-delete)"):with_noremap():with_silent(),
  -- -- replace
  ["n|sr"] = map_cmd("<Plug>(sandwich-replace)"):with_noremap():with_silent(),
  ["x|sr"] = map_cmd("<Plug>(sandwich-replace)"):with_noremap():with_silent(),
  ["o|sr"] = map_cmd("<Plug>(sandwich-replace)"):with_noremap():with_silent(),

  -- Filer
  ["n|<Leader>e"] = map_cmd(":Neotree %<CR>"),
  -- Docker Tool
  ["n|<Leader>dt"] = map_cmd(":DockerToolsOpen<CR>"),
  -- Git
  ["n|<Leader>gs"] = map_cmd(":Git<CR>"):with_noremap(),
  ["n|<Leader>gl"] = map_cmd(":GV<CR>"):with_noremap(),
  ["n|<Leader>gd"] = map_cmd(":Gvdiffsplit<CR>"):with_noremap(),
  ["n|<Leader>gc"] = map_cmd(":Git commit<CR>"):with_noremap(),
  -- -- Gitsigns
  ["n|<Leader>ga"] = map_cmd(":Gitsigns stage_hunk<CR>"):with_noremap(),
  ["v|<Leader>ga"] = map_cmd(":Gitsigns stage_hunk<CR>"):with_noremap(),
  ["n|<Leader>gu"] = map_cmd(":Gitsigns undo_stage_hunk<CR>"):with_noremap(),
  ["v|<Leader>gu"] = map_cmd(":Gitsigns undo_stage_hunk<CR>"):with_noremap(),
  ["v|<Leader>gr"] = map_cmd(":Gitsigns reset_hunk<CR>"):with_noremap(),
  ["n|<Leader>gh"] = map_cmd(":Gitsigns toggle_deleted<CR>:Gitsigns toggle_numhl<CR>:Gitsigns toggle_linehl<CR>")
    :with_noremap()
    :with_silent(),
  ["n|gk"] = map_cmd(":Gitsigns prev_hunk<CR>zz"):with_noremap(),
  ["n|gj"] = map_cmd(":Gitsigns next_hunk<CR>zz"):with_noremap(),
  -- CCC
  ["n|<Leader><CR>"] = map_cmd(":CccPick<CR>"):with_noremap():with_silent(),
  -- Undotree
  ["n|<Leader><Leader>u"] = map_cmd(":UndotreeShow<CR>:UndotreeFocus<CR>")
    :with_noremap()
    :with_silent(),
  -- Telescope
  ["n|<Leader>fg"] = map_cmd(":Telescope git_files<CR>"):with_noremap(),
  ["n|<Leader>fp"] = map_cmd(":Telescope find_files<CR>"):with_noremap(),
  ["n|<Leader><Tab>"] = map_cmd(":Telescope buffers<CR>"):with_noremap(),
  ["n|<Leader>ls"] = map_cmd(":Telescope lsp_document_symbols<CR>"):with_noremap(),
  ["n|<Leader>lds"] = map_cmd(":Telescope lsp_dynamic_workspace_symbols<CR>"):with_noremap(),
  -- Tablular
  ["v|a"] = map_cmd(":Tabularize"):with_noremap(),
  ["v|a,"] = map_cmd(":Tabularize /,<CR>"):with_noremap(),
  ["v|a="] = map_cmd(":Tabularize /=<CR>"):with_noremap(),
  ["v|a:"] = map_cmd(":Tabularize /:\\zs<CR>"):with_noremap(),
  -- FTerm
  ["n|<Leader>tt"] = map_cmd(":FTermOpen<CR>"):with_noremap():with_silent(),
}

local vscode_map = {
  ["n|<Leader>e"] = map_cmd(":call VSCodeNotify('workbench.action.focusSideBar')<CR>"),
}

function MergeTables(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

if vim.g.vscode then
  bind.nvim_load_mapping(MergeTables(map, vscode_map))
else
  bind.nvim_load_mapping(map)
end

-- LSP only
if globals.enable_coc then
  local keyset = vim.keymap.set
  local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

  -- GoTo code navigation
  keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
  keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })

  keyset("n", "gh", "<Plug>(coc-references)", { silent = true })
  keyset("n", "<leader>ca", "<Plug>(coc-codeaction)", opts)
  keyset("n", "<leader>gr", "<Plug>(coc-rename)", { silent = true })
  keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
  keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })
  keyset("n", "<C-k>", "<Plug>(coc-diagnostic-prev)", { silent = true })
  keyset("n", "<C-j>", "<Plug>(coc-diagnostic-next)", { silent = true })
  -- Trouble
  keyset("n", "<Leader>lt", ":<C-u>CocList diagnostics<cr>", opts)
else
  --------------------
  -- nvim-lspconfig --
  --------------------

  -- Lspsaga
  -- Only jump to error
  vim.keymap.set("n", "<leader>p", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)
  vim.keymap.set("n", "<leader>n", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)

  local lspmap = {
    ["n|gh"] = map_cmd(":Lspsaga finder<CR>"):with_noremap():with_silent(),
    ["n|<Leader>ca"] = map_cmd(":Lspsaga code_action<CR>"):with_noremap():with_silent(),
    ["n|gd"] = map_cmd(":Lspsaga goto_definition<CR>"):with_noremap():with_silent(),
    ["n|<Leader>pd"] = map_cmd(":Lspsaga peek_definition<CR>"):with_noremap():with_silent(),
    ["n|gt"] = map_cmd(":Lspsaga goto_type_definition<CR>"):with_noremap():with_silent(),
    ["n|<Leader>pt"] = map_cmd(":Lspsaga peek_type_definition<CR>"):with_noremap():with_silent(),
    ["n|K"] = map_cmd(":Lspsaga hover_doc<CR>"):with_noremap():with_silent(),
    -- Trouble
    ["n|<Leader>lt"] = map_cmd(":Trouble<CR>"):with_noremap(),
  }
  bind.nvim_load_mapping(lspmap)
end
