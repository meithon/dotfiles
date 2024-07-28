local M = {}
--- @diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local ms = ls.multi_snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local k = require("luasnip.nodes.key_indexer").new_key
-- local ts_post = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local postfix_builtin = require("luasnip.extras.treesitter_postfix").builtin
--- @diagnostic enable: unused-local

local calculate_comment_string = require("Comment.ft").calculate
local utils = require("Comment.utils")

--- Get the comment string {beg,end} table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_cstring = function(ctype)
  -- use the `Comments.nvim` API to fetch the comment string for the region (eq. '--%s' or '--[[%s]]' for `lua`)
  local cstring = calculate_comment_string({ ctype = ctype, range = utils.get_region() }) or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format` we want to split the left and right side
  local left, right = utils.unwrap_cstr(cstring)
  -- create a `{left, right}` table for it
  return { left, right }
end
local function create_box(opts)
  local pl = opts.padding_length or 4
  local function pick_comment_start_and_end()
    -- because lua block comment is unlike other language's,
    --  so handle lua ctype
    local ctype = 2
    if vim.opt.ft:get() == "lua" then
      ctype = 1
    end
    local cs = get_cstring(ctype)[1]
    local ce = get_cstring(ctype)[2]
    if ce == "" or ce == nil then
      ce = cs
    end
    return cs, ce
  end
  return {
    -- top line
    f(function(args)
      local cs, ce = pick_comment_start_and_end()
      return cs .. string.rep(string.sub(cs, #cs, #cs), string.len(args[1][1]) + 2 * pl) .. ce
    end, { 1 }),
    t({ "", "" }),
    f(function()
      local cs = pick_comment_start_and_end()
      return cs .. string.rep(" ", pl)
    end),
    i(1, "box"),
    f(function()
      local cs, ce = pick_comment_start_and_end()
      return string.rep(" ", pl) .. ce
    end),
    t({ "", "" }),
    -- bottom line
    f(function(args)
      local cs, ce = pick_comment_start_and_end()
      return cs .. string.rep(string.sub(ce, 1, 1), string.len(args[1][1]) + 2 * pl) .. ce
    end, { 1 }),
  }
end

M.setup = function()
  -- If you're reading this file for the first time, best skip to around line 190
  -- where the actual snippet-definitions start.

  -- Every unspecified option will be set to the default.
  ls.setup({
    keep_roots = true,
    link_roots = true,
    link_children = true,

    -- Update more often, :h events for more info.
    update_events = "TextChanged,TextChangedI",
    -- Snippets aren't automatically removed if their text is deleted.
    -- `delete_check_events` determines on which events (:h events) a check for
    -- deleted snippets is performed.
    -- This can be especially useful when `history` is enabled.
    delete_check_events = "TextChanged",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "choiceNode", "Comment" } },
        },
      },
    },
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = true,
    -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
    -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
    store_selection_keys = "<Tab>",
    -- luasnip uses this function to get the currently active filetype. This
    -- is the (rather uninteresting) default, but it's possible to use
    -- eg. treesitter for getting the current filetype by setting ft_func to
    -- require("luasnip.extras.filetype_functions").from_cursor (requires
    -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
    -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
    ft_func = function()
      return vim.split(vim.bo.filetype, ".", true)
    end,
  })

  ls.filetype_extend("all", { "_" })

  require("luasnip.loaders.from_snipmate").lazy_load() -- Lazy loading

  local javascript = {
    postfix(".let", {
      d(1, function(_, parent)
        return sn(nil, { t("let " .. parent.env.POSTFIX_MATCH .. " = ") })
      end),
    }),
    -- postfix(".const", {
    --   d(1, function(_, parent)
    --     return sn(nil, { t("const " .. parent.env.POSTFIX_MATCH .. " = ") })
    --   end),
    -- }),

    treesitter_postfix({
      trig = ".const",
      reparseBuffer = "live",
      matchTSNode = postfix_builtin.tsnode_matcher.find_topmost_types({
        "expression_statement",
        "call_expression",
        "identifier",
      }),
    }, {
      f(function(_, parent)
        local ls_tsmatch = parent.snippet.env.LS_TSMATCH or {}
        local node_content = table.concat(ls_tsmatch, "\n")

        local _ = vim.split(node_content, ".", { plain = true })
        _ = _[#_]
        local identifier = _:gsub("[\n%(%[%]%)%]]", "")

        local replaced_content = ("const %s = %s"):format(identifier, node_content)
        return vim.split(replaced_content, "\n", { trimempty = false })
      end),
    }),

    postfix(".is type", {
      l("if (typeof " .. l.POSTFIX_MATCH .. " === '"),
      i(1),
      t("') {"),
      -- d(1, function(_, parent)
      --   return sn(nil, { t("if (" .. parent.env.POSTFIX_MATCH .. " === undefined) {") })
      -- end),
      t({ "", "  return " }),
      i(2),
      t({ "", "}" }),
    }),
    -- if (var === undefined) {
    --   {}
    -- }
    postfix(".is undef", {
      l("if (" .. l.POSTFIX_MATCH .. " === undefined) {"),
      -- d(1, function(_, parent)
      --   return sn(nil, { t("if (" .. parent.env.POSTFIX_MATCH .. " === undefined) {") })
      -- end),
      t({ "", "  return " }),
      i(1),
      t({ "", "}" }),
    }),

    s("trylet", {
      t("let "),
      d(2, function(args)
        return sn(nil, { t(args[1]) })
      end, { 1 }),
      t({ " = undefined", "" }),
      t({ "try {", "" }),
      t({ "  " }),
      i(1),
      t({ " = " }),
      sn(3, {
        i(1, "some"),
      }),
      t({ "", "} catch (e) {", "" }),
      t({ "  console.error(e);", "}" }),
    }),
    treesitter_postfix({
      trig = ".return",
      reparseBuffer = "live",
      matchTSNode = postfix_builtin.tsnode_matcher.find_topmost_types({
        "expression_statement",
        "call_expression",
        "identifier",
      }),
    }, {
      f(function(_, parent)
        local ls_tsmatch = parent.snippet.env.LS_TSMATCH or {}
        local node_content = table.concat(ls_tsmatch, "\n")
        local replaced_content = ("return %s"):format(node_content)
        return vim.split(replaced_content, "\n", { trimempty = false })
      end),
    }),

    treesitter_postfix({
      trig = ".await",
      reparseBuffer = "live",
      matchTSNode = postfix_builtin.tsnode_matcher.find_topmost_types({
        "expression_statement",
        "call_expression",
        "identifier",
      }),
    }, {
      f(function(_, parent)
        local ls_tsmatch = parent.snippet.env.LS_TSMATCH or {}
        local node_content = table.concat(ls_tsmatch, "\n")
        local replaced_content = ("await %s"):format(node_content)
        return vim.split(replaced_content, "\n", { trimempty = false })
      end),
    }),
    -- call back
    s("cb", {
      t({ "(" }),
      i(1),
      t({ ") => {" }),
      t({ "", "  " }),
      i(2),
      t({ "", "}" }),
      i(3),
    }),
    -- arrow function
    postfix(".afun", {
      c(3, {
        t(""),
        t("export "),
        t("export default "),
      }),
      l("const " .. l.POSTFIX_MATCH),
      t({ " = (" }),
      i(1),
      t({ ") => {" }),
      t({ "", "  " }),
      i(2),
      t({ "", "}" }),
    }),
    postfix(".func", {
      c(3, {
        t(""),
        t("export "),
        t("export default "),
      }),
      l("function " .. l.POSTFIX_MATCH),
      t({ "(" }),
      i(1),
      t({ ") {" }),
      t({ "", "  " }),
      i(2),
      t({ "", "}" }),
    }),

    postfix(".debug", {
      l("console.log(JSON.stringify(" .. l.POSTFIX_MATCH .. ", null, 2))"),
    }),
    postfix(".last", {
      l(l.POSTFIX_MATCH .. ".slice(-1)[0]"),
    }),
  }
  -- table.insert()
  local lua = {
    postfix(".insert", {
      l("table.insert(" .. l.POSTFIX_MATCH .. ", "),
      i(1),
      t(")"),
    }),
    postfix(".debug", {
      l("print(vim.inspect(" .. l.POSTFIX_MATCH .. "))"),
    }),
    postfix(".merge", {
      l("vim.tbl_extend('force', " .. l.POSTFIX_MATCH .. ", "),
      t(""),
      i(1),
      t(")"),
    }),
    postfix(".foreach", {
      l("for _, " .. l.POSTFIX_MATCH .. " in ipairs(" .. l.POSTFIX_MATCH .. ") do"),
      t({ "", "  " }),
      i(1),
      t({ "", "end" }),
    }),
    postfix(".filter", {
      l("vim.tbl_filter(function(" .. l.POSTFIX_MATCH .. ")"),
      t({ "", "  return " }),
      i(1),
      t({ "", "end, " }),
      i(2),
      t({ ")" }),
    }),
    postfix(".map", {
      l("vim.tbl_map(function(" .. l.POSTFIX_MATCH .. ")"),
      t({ "  return " }),
      i(1),
      t({ "", "end, " }),
      i(2),
      t({ ")" }),
    }),
    postfix(".split", {
      l("vim.split(" .. l.POSTFIX_MATCH .. ", "),
      i(1),
      t(")"),
    }),
  }
  local shell = {
    s("isNumEqual", {
      t({ "if [ " }),
      i(1),
      t({ " -eq " }),
      i(2),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(3),
      t({ "", "fi" }),
    }),

    s("isNumNotEqual", {
      t({ "if [ " }),
      i(1),
      t({ " -ne " }),
      i(2),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(3),
      t({ "", "fi" }),
    }),
    s("isNumLessThan", {
      t({ "# if num1 < num2", "" }),
      t({ "if [ " }),
      i(1),
      t({ " -lt " }),
      i(2),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(3),
      t({ "", "fi" }),
    }),
    s("isExist", {
      t({ "# is exist", "" }),
      t({ "if [ -e " }),
      i(1),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(2),
      t({ "", "fi" }),
    }),
    s("isUndefined", {
      t({ "# is undefined", "" }),
      t({ "if [ -z " }),
      i(1),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(2),
      t({ "", "fi" }),
    }),
    s("isNumGreaterThan", {
      t({ "# if num1 > num2", "" }),
      t({ "if [ " }),
      i(1),
      t({ " -gt " }),
      i(2),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(3),
      t({ "", "fi" }),
    }),
    s("isFileExists", {
      t({ "if [ -f " }),
      i(1),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(2),
      t({ "", "fi" }),
    }),
    s("isDirExists", {
      t({ "if [ -d " }),
      i(1),
      t({ " ]; then" }),
      t({ "", "  " }),
      i(2),
      t({ "", "fi" }),
    }),
    s("isCmdExists", {
      t({ "if command -v " }),
      i(1),
      t({ " &> /dev/null; then" }),
      t({ "", "  " }),
      i(2),
      t({ "", "fi" }),
    }),
    s("func", {
      i(1),
      t({ "() {" }),
      t({ "", "  " }),
      i(2),
      t({ "", "}" }),
    }),
    s("list", {
      t({ "list=(" }),
      i(1),
      t({ ")" }),
    }),
    postfix(".foreach", {
      -- l("for " ..  .. " in ${l.POSTFIX_MATCH[@]}; do"),
      l("for element in ${" .. l.POSTFIX_MATCH .. "[@]}; do"),
      t({ "", "  " }),
      i(1),
      t({ "", "done" }),
    }),
    postfix(".length", {
      l("${#" .. l.POSTFIX_MATCH .. "[@]} # length of " .. l.POSTFIX_MATCH),
    }),

    -- s("switch", {
    --   t({ "case $" }),
    --   i(1),
    --   t({ " in" }),
    --   t({ "", "  pattern1)" }),
    --   t({ "", "    echo pattern1 matched!" }),
    --   i(2),
    --   t({ "", "    ;;" }),
    --   t({ "", "  *)" }),
    --   t({ "", "    echo No pattern matched!" }),
    --   t({ "", "    ;;" }),
    --   t({ "", "esac" }),
    -- }),
    --
    -- -- FIXME:
    -- -- ...local/share/nvim/lazy/LuaSnip/lua/luasnip/extras/fmt.lua:144: Found unescaped { inside placeholder; format[12:180]="{
    -- --   local jobs=("$@")  # Accept a list of jobs as arguments
    -- --   local pids=()      # Array to keep track of background job PIDs
    -- --   # Start background jobs
    -- --   for job in "${"
    -- -- s(
    -- --   "run_jobs",
    -- --   fmt([[
    -- --   run_jobs() {
    -- --     local jobs=("$@")  # Accept a list of jobs as arguments
    -- --     local pids=()      # Array to keep track of background job PIDs
    -- --
    -- --     # Start background jobs
    -- --     for job in "${jobs[@]}"; do
    -- --       bash -c "$job" &
    -- --       pids+=($!)
    -- --     done
    -- --
    -- --     # Wait for all background jobs to complete
    -- --     for pid in "${pids[@]}"; do
    -- --       wait $pid
    -- --       local exit_status=$?
    -- --       if [ $exit_status -ne 0 ]; then
    -- --         echo "Job $pid failed with exit status $exit_status"
    -- --         return 1
    -- --       fi
    -- --     done
    -- --
    -- --     echo "All jobs completed successfully."
    -- --     return 0
    -- --   }
    -- --
    -- --   # Define jobs as a list
    -- --   jobs=(
    -- --     "sleep 2"
    -- --     "sleep 3 && false"  # Simulate an error
    -- --     "sleep 1"
    -- --   )
    -- --
    -- --   # Run the jobs
    -- --   run_jobs "${jobs[@]}"
    -- -- ]])
    -- -- ),
    -- postfix(".debug", {
    --   l('echo -e "\\033[0;32m  DEBUG: ' .. l.POSTFIX_MATCH .. '=\\"${!' .. l.POSTFIX_MATCH .. '}\\033[0m"'),
    -- }),
  }

  local all = {
    s({ trig = "box" }, create_box({ padding_length = 8 })),
    s({ trig = "bbox" }, create_box({ padding_length = 20 })),
    -- s("DDD", {
    --   fmt([[
    --   main.ts
    --     |
    --     v
    --   interfaces/controllers
    --     |          \
    --     |           \
    --     v            v
    --   application  interfaces/dtos
    --     |
    --     v
    --   domain/user    domain/post
    --     |                 |
    --     v                 v
    --   infrastructure/repositories
    --
    --   ```sh
    --   touch main.ts
    --
    --   mkdir application/user
    --   touch application/user/service.ts
    --
    --   mkdir domain/user
    --   touch domain/user/user.ts
    --   touch domain/user/user_repository.ts
    --   touch domain/user/user_service.ts
    --
    --
    --   mkdir infrastructure/repositories
    --   touch infrastructure/repositories/user_repository_impl.ts
    --   touch infrastructure/database.ts
    --
    --   mkdir interface/controllers
    --   touch interface/controllers/user_controller.ts
    --
    --   mkdir dtos
    --   touch dtos/user_dto.ts
    --   ```
    --   ]]),
    -- }),
  }

  ls.filetype_extend("all", { "_" })
  ls.add_snippets("javascript", javascript)
  ls.add_snippets("typescript", javascript)
  ls.add_snippets("typescriptreact", javascript)
  ls.add_snippets("lua", lua)
  ls.add_snippets("sh", shell)
  ls.add_snippets("bash", shell)
  ls.add_snippets("zsh", shell)
  ls.add_snippets("all", all)

  require("luasnip").config.setup({
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "GruvboxOrange" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "GruvboxBlue" } },
        },
      },
    },
  })
end

return M
