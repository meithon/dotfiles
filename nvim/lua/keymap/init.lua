local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

-- Only jump to error
vim.keymap.set("n", "<c-e>", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
vim.keymap.set("n", "<c-E>", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

local map = {
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

	-- Lightspeed
	["n|<Leader>j"] = map_cmd("<Plug>Lightspeed_s"):with_noremap():with_silent(),
	["n|<Leader>k"] = map_cmd("<Plug>Lightspeed_S"):with_noremap():with_silent(),
	["v|<Leader>j"] = map_cmd("<Plug>Lightspeed_s"):with_noremap():with_silent(),
	["v|<Leader>k"] = map_cmd("<Plug>Lightspeed_S"):with_noremap():with_silent(),

	-- SearchX
	["n|?"] = map_cmd("<Cmd>call searchx#start({ 'dir': 0 })<CR>"),
	["n|/"] = map_cmd("<Cmd>call searchx#start({ 'dir': 1 })<CR>"),
	["x|?"] = map_cmd("<Cmd>call searchx#start({ 'dir': 0 })<CR>"),
	["x|/"] = map_cmd("<Cmd>call searchx#start({ 'dir': 1 })<CR>"),

	-- VFiler
	["n|<Leader>e"] = map_cmd(":VFiler<CR>"),
	-- Docker Tool
	["n|<Leader>dt"] = map_cmd(":DockerToolsOpen<CR>"),
	-- Lspsaga
	["n|gh"] = map_cmd(":Lspsaga lsp_finder<CR>"):with_noremap():with_silent(),
	["n|<Leader>ca"] = map_cmd(":Lspsaga code_action<CR>"):with_noremap():with_silent(),
	["n|gr"] = map_cmd(":Lspsaga rename<CR>"):with_noremap():with_silent(),
	["n|gd"] = map_cmd(":Lspsaga peek_definition<CR>"):with_noremap():with_silent(),
	["n|K"] = map_cmd(":Lspsaga hover_doc<CR>"):with_noremap():with_silent(),
	["n|<C-k>"] = map_cmd(":Lspsaga diagnostic_jump_prev<CR>"):with_noremap():with_silent(),
	["n|<C-j>"] = map_cmd(":Lspsaga diagnostic_jump_next<CR>"):with_noremap():with_silent(),
	-- Trouble
	["n|<Leader>lt"] = map_cmd(":Trouble<CR>"):with_noremap(),
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
	["n|<Leader>gh"] = map_cmd(":Gitsigns toggle_deleted<CR>:Gitsigns toggle_numhl<CR>"):with_noremap():with_silent(),
	["n|gk"] = map_cmd(":Gitsigns prev_hunk<CR>zz"):with_noremap(),
	["n|gj"] = map_cmd(":Gitsigns next_hunk<CR>zz"):with_noremap(),
	-- CCC
	["n|<Leader><CR>"] = map_cmd(":CccPick<CR>"):with_noremap():with_silent(),
	-- Undotree
	["n|<Leader><Leader>u"] = map_cmd(":UndotreeShow<CR>:UndotreeFocus<CR>"):with_noremap():with_silent(),
	-- Telescope
	["n|<Leader>fg"] = map_cmd(":Telescope git_files<CR>"):with_noremap(),
	["n|<Leader><Tab>"] = map_cmd(":Telescope buffers<CR>"):with_noremap(),
	-- EasyAlign
	["v|af"] = map_cmd("<Plug>(EasyAlign)"):with_noremap(),
	-- FTerm
	["n|<Leader>tt"] = map_cmd(":FTermOpen<CR>"):with_noremap():with_silent(),
}

bind.nvim_load_mapping(map)
