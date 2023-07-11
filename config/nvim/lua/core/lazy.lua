local global = require("core.global")
local vim_path = global.vim_path
local modules_dir = vim_path .. "/lua/modules"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins_file = {}
local tmp = vim.split(vim.fn.globpath(modules_dir, "*.lua"), "\n")

for _, f in ipairs(tmp) do
  plugins_file[#plugins_file + 1] = f:sub(#modules_dir - 6, -1)
end

local plugin_list = {}
if vim.g.vscode then
  local repos = require("modules.editor")
  for _, plugin in ipairs(repos) do
    table.insert(plugin_list, plugin)
  end
else
  for _, m in ipairs(plugins_file) do
    local repos = require(m:sub(0, #m - 4))
    for _, plugin in ipairs(repos) do
      table.insert(plugin_list, plugin)
    end
  end
end

require("lazy").setup(plugin_list)
