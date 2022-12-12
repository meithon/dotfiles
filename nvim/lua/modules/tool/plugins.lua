local tool = {}
local conf = require("module.tool.config")

tool["bayne/vim-dot-http"] = {
	opt = true,
}
tool["chipsenkbeil/distant.nvim"] = {
	opt = false,
}
tool["numToStr/FTerm.nvim"] = {
	opt = true,
}
tool["lewis6991/impatient.nvim"] = {
	opt = true,
}
tool["dstein64/vim-startuptime"] = {
	opt = true,
}
tool["folke/which-key.nvim"] = {
	opt = true,
}
tool["glepnir/lspsaga.nvim"] = {
	opt = true,
}
tool["kkvh/vim-docker-tools"] = {
	opt = true,
}
tool["skanehira/translate.vim"] = {
	opt = true,
}
tool["thinca/vim-qfreplace"] = {
	opt = true,
}
tool["kevinhwang91/nvim-bqf"] = {
	opt = true,
	ft = "qf",
}
tool["uga-rosa/ccc.nvim"] = {
	opt = true,
}
tool["tpope/vim-fugitive"] = {
	opt = true,
  cmd = {"Git", "Gdiffsplit", "Gvdiffsplit"},
  require = {{"junegunn/gv.vim", opt = true, cmd = "GV"}}
}
tool["lewis6991/gitsigns.nvim"] = {
	opt = true,
  event = {"FocusLost", "CursorHold", "BufRead"},
  cmd = "Gitsigns",
  config = conf.gitsigns
}
tool["mbbill/undotree"] = {
	opt = true,
  cmd = {"UndotreeShow", "UndotreeFocus"}
}
tool["nvim-telescope/telescope.nvim"] = {
	opt = true,
	module = "telescope",
	cmd = "Telescope",
	requires = {
		{ "nvim-lua/plenary.nvim", opt = false },
		{ "nvim-lua/popup.nvim", opt = true },
	},
}
tool["nvim-lua/plenary.nvim"] = {
	opt = false,
}
tool["nvim-lua/popup.nvim"] = {
	opt = true,
}
tool["nvim-lua/popup.nvim"] = {
	opt = true,
}
tool["obaland/vfiler.vim"] = {
	opt = true,
  cmd = "VFiler"
}
all["obaland/vfiler-column-devicons"] = {
	opt = true,
}
return tool
