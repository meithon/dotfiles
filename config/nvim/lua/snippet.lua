local M = {}

function M.setup()
  local ls = require("luasnip")
  local pf = require("luasnip.extras.postfix").postfix
  local t = ls.text_node
  local i = ls.insert_node
  local f = ls.function_node

  -- Only trigger .map snippet when preceding expression is array via LSP hover
  local function is_array_before_map()
    local trigger = ".map"
    local params = vim.lsp.util.make_position_params()
    params.position.character = params.position.character - #trigger
    if params.position.character < 0 then
      return false
    end
    local results = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 200)
    if not results then
      return false
    end
    for _, res in pairs(results) do
      if res.result and res.result.contents then
        local md = vim.lsp.util.convert_input_to_markdown_lines(res.result.contents)
        local text = table.concat(md, "")
        if text:match("[Aa]rray<") or text:match("%[%]") then
          return true
        end
      end
    end
    return false
  end

  local map_snip = pf({ trig = ".map", wordTrig = false, condition = is_array_before_map }, {
    f(function(_, parent)
      return parent.env.POSTFIX_MATCH .. ".map("
    end, {}),
    i(1, "_"),
    t(" => {"),
    t({ "", "  " }),
    i(2),
    t({ "", "}" }),
    t(")"),
  })

  ls.add_snippets("javascript", { map_snip })
  ls.add_snippets("javascriptreact", { map_snip })
  ls.add_snippets("typescript", { map_snip })
  ls.add_snippets("typescriptreact", { map_snip })
end

return M
