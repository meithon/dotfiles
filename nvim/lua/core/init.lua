local load_core = function ()
  print("core loaded")
  require("core.options")
  require("core.mapping")
  require("keymap")
end

load_core()
