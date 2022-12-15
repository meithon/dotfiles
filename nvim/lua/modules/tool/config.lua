local config = {}

function config.dot_http()
  vim.g.dot_http_env = 'dev'
end

function config.distant()
  require('distant').setup {
    ['*'] = require('distant.settings').chip_default()
  }
end

function config.fterm()
  require'FTerm'.setup({
      border = 'double',
      dimensions  = {
          height = 0.9,
          width = 0.9,
      },
  })

  -- create command
  vim.api.nvim_create_user_command('FTermOpen', require('FTerm').open, { bang = true })
  vim.api.nvim_create_user_command('FTermClose', require('FTerm').close, { bang = true })
  vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })
end

function config.which_key()
  require("which-key").setup({
    key_labels = {
      ["<space>"] = "<SPACE>",
      ["<CR>"] = "<ENTER>",
      ["<Tab>"] = "<TAB>",
    },
    triggers = { "<leader>" }, -- If not written, conflict with vfiler to cause error occurs
    disable = {
      buftypes = { "vfiler", "nofile" },
      filetypes = { "vfiler", "nofile" },
    },
  })
end

function config.lspsaga()
  require("lspsaga").init_lsp_saga({
    symbol_in_winbar = {
      in_custom = true,
    },
  })
  local function get_file_name(include_path)
    local file_name = require("lspsaga.symbolwinbar").get_file_name()
    if vim.fn.bufname("%") == "" then
      return ""
    end
    if include_path == false then
      return file_name
    end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
    local path_list = vim.split(string.gsub(vim.fn.expand("%:~:.:h"), "%%", ""), sep)
    local file_path = ""
    for _, cur in ipairs(path_list) do
      file_path = (cur == "." or cur == "~") and "" or file_path .. cur .. " " .. "%#LspSagaWinbarSep#>%*" .. " %*"
    end
    return file_path .. file_name
  end

  local function config_winbar()
    local exclude = {
      ["terminal"] = true,
      ["toggleterm"] = true,
      ["prompt"] = true,
      ["NvimTree"] = true,
      ["help"] = true,
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
      vim.wo.winbar = ""
    else
      local ok, lspsaga = pcall(require, "lspsaga.symbolwinbar")
      local sym
      if ok then
        sym = lspsaga.get_symbol_node()
      end
      local win_val = ""
      win_val = get_file_name(true) -- set to true to include path
      if sym ~= nil then
        win_val = win_val .. sym
      end
      vim.wo.winbar = win_val
    end
  end

  local events = { "BufEnter", "BufWinEnter", "CursorMoved" }

  vim.api.nvim_create_autocmd(events, {
    pattern = "*",
    callback = function()
      config_winbar()
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function()
      config_winbar()
    end,
    pattern = "LspsagaUpdateSymbol",
  })
end

function config.bqf()
  require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        show_title = false,
        should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match('^fugitive://') then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end
    },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
        drop = 'o',
        openc = 'O',
        split = '<C-s>',
        tabdrop = '<C-t>',
        -- set to empty string to disable
        tabc = '',
        ptogglemode = 'z,',
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
  })
end

function config.gitsigns()
  require('gitsigns').setup()
end

function config.ccc()
  local ColorInput = require("ccc.input")
  local convert = require("ccc.utils.convert")

  local RgbHslCmykInput = setmetatable({
      name = "RGB/HSL/CMYK",
      max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
      min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      delta = { 1 / 255, 1 / 255, 1 / 255, 1, 0.01, 0.01, 0.005, 0.005, 0.005, 0.005 },
      bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
  }, { __index = ColorInput })

  function RgbHslCmykInput.format(n, i)
      if i <= 3 then
          -- RGB
          n = n * 255
      elseif i == 5 or i == 6 then
          -- S or L of HSL
          n = n * 100
      elseif i >= 7 then
          -- CMYK
          return ("%5.1f%%"):format(math.floor(n * 200) / 2)
      end
      return ("%6d"):format(n)
  end

  function RgbHslCmykInput.from_rgb(RGB)
      local HSL = convert.rgb2hsl(RGB)
      local CMYK = convert.rgb2cmyk(RGB)
      local R, G, B = unpack(RGB)
      local H, S, L = unpack(HSL)
      local C, M, Y, K = unpack(CMYK)
      return { R, G, B, H, S, L, C, M, Y, K }
  end

  function RgbHslCmykInput.to_rgb(value)
      return { value[1], value[2], value[3] }
  end

  function RgbHslCmykInput:_set_rgb(RGB)
      self.value[1] = RGB[1]
      self.value[2] = RGB[2]
      self.value[3] = RGB[3]
  end

  function RgbHslCmykInput:_set_hsl(HSL)
      self.value[4] = HSL[1]
      self.value[5] = HSL[2]
      self.value[6] = HSL[3]
  end

  function RgbHslCmykInput:_set_cmyk(CMYK)
      self.value[7] = CMYK[1]
      self.value[8] = CMYK[2]
      self.value[9] = CMYK[3]
      self.value[10] = CMYK[4]
  end

  function RgbHslCmykInput:callback(index, new_value)
      self.value[index] = new_value
      local v = self.value
      if index <= 3 then
          local RGB = { v[1], v[2], v[3] }
          local HSL = convert.rgb2hsl(RGB)
          local CMYK = convert.rgb2cmyk(RGB)
          self:_set_hsl(HSL)
          self:_set_cmyk(CMYK)
      elseif index <= 6 then
          local HSL = { v[4], v[5], v[6] }
          local RGB = convert.hsl2rgb(HSL)
          local CMYK = convert.rgb2cmyk(RGB)
          self:_set_rgb(RGB)
          self:_set_cmyk(CMYK)
      else
          local CMYK = { v[7], v[8], v[9], v[10] }
          local RGB = convert.cmyk2rgb(CMYK)
          local HSL = convert.rgb2hsl(RGB)
          self:_set_rgb(RGB)
          self:_set_hsl(HSL)
      end
  end

  local ccc = require("ccc")
  local mapping = ccc.mapping

  ccc.setup({
      default_color = "#ffffff",
      inputs = {
          RgbHslCmykInput,
      },
      mappings = {
          t = mapping.toggle_alpha,
          L = mapping.increase5,
          a = mapping.increase10,
          H = mapping.decrease5,
          i = mapping.decrease10,
          I = mapping.set0,
          A = mapping.set100,
      }
  })
end

function config.telescope()
  require("telescope").setup({
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key",
        },
      },
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- please take a look at the readme of the extension you want to configure
      -- }
    },
  })
end

function config.vfiler()
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
end

return config
