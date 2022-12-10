local global = require("core.global")
-- Create cache dir and data dirs
local createdir = function()
	local data_dir = {
		global.cache_dir .. "backup",
		global.cache_dir .. "session",
		global.cache_dir .. "swap",
		global.cache_dir .. "tags",
		global.cache_dir .. "undo",
	}
	-- Only check whether cache_dir exists, this would be enough.
	if vim.fn.isdirectory(global.cache_dir) == 0 then
		os.execute("mkdir -p " .. global.cache_dir)
		for _, v in pairs(data_dir) do
			if vim.fn.isdirectory(v) == 0 then
				os.execute("mkdir -p " .. v)
			end
		end
	end
end

local load_core = function()
	local pack = require("core.pack")
	createdir()
	pack.ensure_plugins()
	require("core.options")
	require("core.mapping")
	require("keymap")
	pack.load_compile()

	vim.api.nvim_command([[colorscheme tokyonight]])
end

load_core()
