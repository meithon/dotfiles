-- vfiler configuration (Explorer style)
require'vfiler/config'.setup {
  options = {
    columns = 'indent,devicons,name,git',
    auto_cd = true,
    auto_resize = true,
    keep = true,
    layout = 'left',
    width = 30,
    git = {
      enabled = true,
      untracked = true,
      ignored = false,
    },
  },
}
