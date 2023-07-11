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

local changeDiagnosticSign = function()
  local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

local wslClicpboard = function()
  if global.is_wsl then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "win32yank.exe -i",
        ["*"] = "win32yank.exe -i",
      },
      paste = {
        ["+"] = "win32yank.exe -o",
        ["*"] = "win32yank.exe -o",
      },

      cache_enabled = 1,
    }
  end
end

local load_core = function()
  createdir()
  require("core.options")
  require("core.mapping")
  require("keymap")
  -- for startify
  require("core.lazy")

  changeDiagnosticSign()
  wslClicpboard()
end

load_core()
