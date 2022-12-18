local function load_options()
	local HOME_PATH = os.getenv("HOME")
	local global_local = {
		clipboard = "unnamedplus",
		termguicolors = true,
		relativenumber = true,
		number = true,
		mouse = "a",

		expandtab = true,
		tabstop = 2,
		shiftwidth = 2,
		softtabstop = 2,

		smartindent = true,
		undofile = true,
		undodir = HOME_PATH .. "/.vim/undodir",
		cursorline = true,
	}
	for name, value in pairs(global_local) do
		vim.o[name] = value
	end
end

load_options()
