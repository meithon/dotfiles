local config = {}

function config.comment()
  require('Comment').setup(
    {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
          ---Block-comment toggle keymap
          block = 'gbc',
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
          ---Line-comment keymap
          line = 'gc',
          ---Block-comment keymap
          block = 'gb',
      },
      ---LHS of extra mappings
      extra = {
          ---Add comment on the line above
          above = 'gcO',
          ---Add comment on the line below
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappin--[[ gs ]]
      mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
          ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
          extended = false,
      },
      ---Function to call before (un)comment
      pre_hook = function(ctx)
          -- Only calculate commentstring for tsx filetypes
          if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'javascriptreact' then
              local U = require('Comment.utils')

              -- Determine whether to use linewise or blockwise commentstring
              local type = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'

              -- Determine the location where to calculate commentstring from
              local location = nil
              if ctx.ctype == U.ctype.blockwise then
                  location = require('ts_context_commentstring.utils').get_cursor_location()
              elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                  location = require('ts_context_commentstring.utils').get_visual_start_location()
              end

              return require('ts_context_commentstring.internal').calculate_commentstring({
                  key = type,
                  location = location,
              })
          end
      end,
      ---Function to call after (un)comment
      post_hook = nil,
    }
  )
end

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
