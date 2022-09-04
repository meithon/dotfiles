lua << END
local status, lualine = pcall(require, "lualine")
if (not status) then return end

local main_color = "#417894"
local sub_color = "#302B2D"

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox_dark',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_c = { 'branch' },
    lualine_b = { {
        'buffers',
        buffers_color = {
            -- Same values as the general color option can be used here.
            active = {
                bg=main_color,
                fg="#f0f0f0"
            },     -- Color for active buffer.
            inactive = {
                bg=sub_color,
                fg=main_color
            }
        },
        symbols = {
          modified = ' ●',      -- Text to show when the buffer is modified
          alternate_file = '', -- Text to show to identify the alternate file
          directory =  '',     -- Text to show when the buffer is a directory
        },
    },
    },
    lualine_x = {
      { 'diagnostics', sources = { "coc" }, symbols = { error = ' ', warn = ' ', info = ' ',
        hint = ' ' } },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive' }
}
END
