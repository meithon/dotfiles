require("noice").setup({
	cmdline = {
		-- cant work this
		enabled = false,
		view = true,
		format = {
			cmdline = false,
			search_down = false,
			search_up = false,
			filter = false,
			lua = false,
			help = false,
		},
	},
})

vim.notify = require("notify")
