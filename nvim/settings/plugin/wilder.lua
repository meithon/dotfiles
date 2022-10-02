local wilder = require('wilder')
wilder.setup({ modes = { ':', '/', '?' } })
-- Disable Python remote plugin
wilder.set_option('use_python_remote_plugin', 0)

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.cmdline_pipeline({
      fuzzy = 1,
      fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    wilder.search_pipeline()
  ),
})

wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlighter = {
    wilder.lua_fzy_highlighter(), -- requires fzy-lua-native vim plugin found
    -- at https://github.com/romgrk/fzy-lua-native
  },
  highlights = {
    accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }),
  },
  left = { ' ', wilder.popupmenu_devicons() },
  right = { ' ', wilder.popupmenu_scrollbar() },
}))
