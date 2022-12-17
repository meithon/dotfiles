local tool = {}
local conf = require("modules.tool.config")

tool["bayne/vim-dot-http"] = {
  opt = true,
  config = conf.dot_http,
  ft = "http",
  cmd = "DotHttp"
}
tool["chipsenkbeil/distant.nvim"] = {
	opt = false,
  config = conf.distant,
}
tool["numToStr/FTerm.nvim"] = {
	opt = true,
  config = conf.fterm,
  cmd = {"FTermOpen", "FTermClose", "FTermClose"},
}
tool["lewis6991/impatient.nvim"] = {
	opt = true,
}
tool["dstein64/vim-startuptime"] = {
	opt = true,
  cmd = "StartupTime"
}
tool["folke/which-key.nvim"] = {
	opt = true,
  config = conf.which_key,
  event = "InsertLeave",
}
tool["glepnir/lspsaga.nvim"] = {
	opt = true,
	config = conf.lspsaga,
	cmd = { "Lspsaga" },
	module = { "lspsaga" },
}
tool["kkvh/vim-docker-tools"] = {
	opt = true,
  cmd = "DockerToolsOpen",
}
tool["skanehira/translate.vim"] = {
	opt = true,
  cmd = "Translate",
}
tool["thinca/vim-qfreplace"] = {
	opt = true,
  event = "QuickFixCmdPost"
}
tool["kevinhwang91/nvim-bqf"] = {
	opt = true,
	ft = "qf",
  config = conf.bqf
}
tool["uga-rosa/ccc.nvim"] = {
	opt = true,
  cmd = "CocPicker",
  config = conf.ccc,
}
tool["tpope/vim-fugitive"] = {
	opt = true,
  cmd = {"GV", "Git", "Gdiffsplit", "Gvdiffsplit"},
}
tool["junegunn/gv.vim"] = {
  opt = true,
  require = {{"tpope/vim-fugitive"}},
  cmd = {"GV"},
  
}
tool["lewis6991/gitsigns.nvim"] = {
  config = conf.gitsigns
}
tool["mbbill/undotree"] = {
	opt = true,
  cmd = {"UndotreeShow", "UndotreeFocus"}
}
tool["nvim-telescope/telescope.nvim"] = {
	opt = true,
  config = conf.telescope,
	module = {"telescope"},
	cmd = {"Telescope"},
	requires = {
		{ "nvim-lua/plenary.nvim", module = {"plenary"}},
		{ "nvim-lua/popup.nvim", module = {"popup"}},
	},
}
tool["obaland/vfiler.vim"] = {
	opt = true,
  cmd = "VFiler",
  config = conf.vfiler,
  requires = {
    {"obaland/vfiler-column-devicons"}
  }
}

return tool
