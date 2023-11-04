return {

  {
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
    wants = { "nvim-treesitter" }, -- or require if not used so far
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
  },
  { -- bracket highlight
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  { -- auto 改行
    "hrsh7th/nvim-insx",
    config = function()
      require("insx.preset.standard").setup()
      local insx = require("insx")
      -- Simple pair deletion recipe.
      local function your_recipe(option)
        return {
          action = function(ctx)
            if option.allow_space then
              ctx.remove([[\s*\%#\s*]])
            end
            ctx.send("<BS><Right><BS>")
          end,
          enabled = function(ctx)
            if option.allow_space then
              return ctx.match([[(\s*\%#\s*)]])
            end
            return ctx.match([[(\%#)]])
          end,
        }
      end
      local insx = require("insx")

      insx.add("'", your_recipe)

      -- Simple pair deletion recipe.
      --
    end,
  },
  -- 	{
  -- 		"nvimdev/dyninput.nvim",
  -- 		config = function()
  -- 			local rs = require("dyninput.lang.rust")
  -- 			local ms = require("dyninput.lang.misc")
  -- 			require("dyninput").setup({
  -- 				c = {
  -- 					["-"] = {
  -- 						{ "->", ms.c_struct_pointer },
  -- 						{ "_",  ms.snake_case },
  -- 					},
  -- 				},
  -- 				rust = {
  -- 					[";"] = {
  -- 						{ "::", rs.double_colon },
  -- 						{ ": ", rs.single_colon },
  -- 					},
  -- 					["="] = { " => ", rs.fat_arrow },
  -- 					["-"] = {
  -- 						{ " -> ", rs.thin_arrow },
  -- 						{ "_",    ms.snake_case },
  -- 					},
  -- 					["\\"] = { "|!| {}", rs.closure_fn },
  -- 				},
  -- 			})
  -- 		end,
  -- 		dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- 	},
}
