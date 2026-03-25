local M = {}

local function system_call(...)
  local cmd = { ... }
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

local function create_fcitx5_strategy(english_im)
  return {
    get_state = function()
      return tonumber(system_call("fcitx5-remote")) or 0
    end,
    get_name = function()
      return system_call("fcitx5-remote", "-n") or ""
    end,
    to_english = function()
      system_call("fcitx5-remote", "-s", english_im)
    end,
    restore = function(name)
      local target = name ~= "" and name or english_im
      system_call("fcitx5-remote", "-s", target)
    end,
  }
end

local function create_noop_strategy()
  return {
    get_state = function()
      return 0
    end,
    get_name = function()
      return ""
    end,
    to_english = function() end,
    restore = function(_) end,
  }
end

function M.setup(opts)
  opts = opts or {}
  local english_im = opts.english_im or "keyboard-us"
  local strategy = create_noop_strategy()

  if vim.fn.executable("fcitx5-remote") == 1 then
    strategy = create_fcitx5_strategy(english_im)
  end

  local ime_state = 0
  local ime_name = ""
  local group = vim.api.nvim_create_augroup("FcitxImeRestore", { clear = true })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = function()
      ime_state = strategy.get_state()
      ime_name = strategy.get_name()
      vim.schedule(function()
        strategy.to_english()
      end)
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = function()
      vim.schedule(function()
        if ime_state == 2 then
          strategy.restore(ime_name)
        end
      end)
    end,
  })
end

return M
