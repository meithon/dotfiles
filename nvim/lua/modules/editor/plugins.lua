local editor = {}
local conf = require("modules.editor.config")

editor["numToStr/Comment.nvim"] = {
	opt = true,
	keys = { "gc" },
	config = conf.comment,
}
editor["windwp/nvim-autopairs"] = {
	opt = true,
	event = "InsertEnter",
	config = conf.autopairs,
}
editor["nacro90/numb.nvim"] = {
	opt = false,
	config = conf.numb,
}
editor["matze/vim-move"] = {
	opt = true,
	keys = { "<ALT>" },
}
editor["junegunn/vim-easy-align"] = {
	opt = true,
	keys = { "<Plug>(EasyAlign)" },
}
editor["ggandor/lightspeed.nvim"] = {
	opt = true,
	config = conf.lightspeed,
	keys = { "<Plug>Lightspeed_s", "<Plug>Lightspeed_S", "f", "F" },
}
editor["chaoren/vim-wordmotion"] = {
	opt = true,
	keys = { "w", "e", "b", "W", "E", "B" },
}
editor["hrsh7th/vim-searchx"] = {
	opt = true,
	keys = { "/", "?" },
	config = conf.searchx(),
}
editor["max397574/better-escape.nvim"] = {
	opt = true,
	event = "InsertEnter",
	config = conf.better_escape,
}
editor["machakann/vim-sandwich"] = {
	opt = true,
	wants = { "vim-wordmotion" },
	keys = { "sa", "sd", "sr" },
}
editor["tversteeg/registers.nvim"] = {
	opt = true,
	branch = "main",
	keys = { '"' },
	config = conf.registers,
}
editor["NvChad/nvim-colorizer.lua"] = {
	opt = true,
}
editor["mg979/vim-visual-multi"] = {
	opt = true,
	branch = "master",
	keys = { "<C-n>" },
}

return editor
