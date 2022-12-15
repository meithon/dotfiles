local config = {}

function config.autopairs()
  require('nvim-autopairs').setup()
end

function config.numb()
  require('numb').setup()
end

function config.lightspeed()
  require'lightspeed'.setup { }
end

function config.searchx()
  local g = {}

  -- Auto jump if the recent input matches to any marker.
  g.auto_accept = true
  -- The scrolloff value for moving to next/prev.
  g.scrolloff = vim.g.scrolloff
  -- To enable scrolling animation.
  g.scrolltime = 500
  -- To enable auto nohlsearch after cursor is moved
  g.nohlsearch = { jump = true }
  -- Marker characters.
  g.markers = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }

  -- Convert search pattern.
  --[[function g.searchx.convert(input)
    if not string.match(input, '\k') then
      return '\V' .. input
    end
    return string.sub(input, 1, 1) .. string.gsub(string.sub(input, 2), '\@<! ', '.\{-}', 'g')
  end]]

  vim.g.serachx = g
end

function config.better_escape()
  require("better_escape").setup {
      mapping = { "jk" }, -- a table with mappings to use
      timeout = 200, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      clear_empty_lines = false, -- clear line after escaping if there is only whitespace
      keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
  }
end

function config.registers()
  require("registers").setup()
end

function config.colorizer()
  require'colorizer'.setup()
end

return config
