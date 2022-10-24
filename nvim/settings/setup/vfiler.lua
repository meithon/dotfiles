-- vfiler configuration (Explorer style)
require'vfiler/config'.setup {
  options = {
    columns = 'indent,devicons,name,git,mode,size',
    auto_cd = true,
    auto_resize = true,
    keep = true,
    layout = 'left',
    width = 50,
    git = {
      enabled = true,
      untracked = true,
      ignored = true,
    },
  },
}
