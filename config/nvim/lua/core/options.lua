local function load_options()
	local HOME_PATH = os.getenv("HOME")
	local global_local = {
		clipboard = "unnamedplus",
		termguicolors = true,
		relativenumber = true,
		number = true,
		mouse = "a",
		expandtab = false,
		tabstop = 2,
		shiftwidth = 2,
		softtabstop = 2,
		scrolloff = 16,
		pumheight = 20,
		smartindent = true,
		undofile = true,
		undodir = HOME_PATH .. "/.vim/undodir",
		cursorline = true,
		swapfile = false,
	}
	for name, value in pairs(global_local) do
		vim.o[name] = value
	end
end

load_options()
