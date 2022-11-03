require("which-key").setup({
	key_labels = {
		["<space>"] = "<SPACE>",
		["<CR>"] = "<ENTER>",
		["<Tab>"] = "<TAB>",
	},
	triggers = { "<leader>" }, -- If not written, conflict with vfiler to cause error occurs
	disable = {
		buftypes = { "vfiler", "nofile" },
		filetypes = { "vfiler", "nofile" },
	},
})
