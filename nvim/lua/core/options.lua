local function load_options()
  local global_local = {
    relativenumber = true,
  }
  for name, value in pairs(global_local) do
    vim.o[name] = value
  end
end

load_options()
