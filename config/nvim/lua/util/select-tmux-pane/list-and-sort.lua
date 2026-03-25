local function render_lines(panes)
  for _, pane in ipairs(panes) do
    print(
      string.format(
        "pane_id=%s | session=%s | window=%s | path=%s",
        pane.pane_id,
        pane.session_name,
        pane.window_index,
        pane.pane_current_path
      )
    )
  end
end

local function list_tmux_pane_with_rank()
  local tmux_list = vim.fn.system(
    [[tmux list-panes -a -F $'#{session_id}\t#{window_index}\t#{pane_index}\t#{window_name}\t#{pane_id}\t#{pane_pid}\t#{pane_current_path}']]
  )
  -- 4	1	0	 zsh	%19	170756	/home/mei/ghq/github.com/olimorris/codecompanion.nvim
  -- 4	1	1	 zsh	%37	522467	/home/mei/ghq/github.com/olimorris/codecompanion.nvim
  -- 4	1	2	 zsh	%28	356001	/home/mei/dotfiles
  -- 4	1	3	 zsh	%38	525654	/home/mei/ghq/github.com/olimorris/codecompanion.nvim
  -- 4	1	4	 zsh	%43	586645	/home/mei/ghq/github.com/olimorris/codecompanion.nvim
  -- 4	1	5	 zsh	%46	655835	/home/mei/ghq/github.com/olimorris/codecompanion.nvim
  -- 4	2	0	 zsh	%44	643055	/home/mei/ghq/github.com/olimorris/codecompanion.nvim
  -- codecompanion	1	0	 node	%34	440281	/home/mei/workspace/private/playground/codecompanion
  -- codecompanion	1	1	 node	%36	445321	/home/mei/workspace/private/playground/codecompanion
  -- codecompanion	1	2	 node	%35	441010	/home/mei/workspace/private/playground/codecompanion

  local fields = {
    "session_name",
    "window_index",
    "pane_index",
    "window_name",
    "pane_id",
    "pane_pid",
    "pane_current_path",
  }

  local function parse_panes(str, field_list)
    local res = {}
    local line_index = 1
    for line in str:gmatch("[^\n]+") do
      local obj = { _index = line_index }
      local i = 1
      for value in line:gmatch("[^\t]+") do
        local key = field_list[i]
        if key then
          obj[key] = value
        end
        i = i + 1
      end
      table.insert(res, obj)
      line_index = line_index + 1
    end
    return res
  end

  local function split_path(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
      table.insert(parts, part)
    end
    return parts
  end

  local function common_prefix_len(a, b)
    local a_parts = split_path(a)
    local b_parts = split_path(b)
    local max_len = math.min(#a_parts, #b_parts)
    local count = 0
    for i = 1, max_len do
      if a_parts[i] ~= b_parts[i] then
        break
      end
      count = count + 1
    end
    return count
  end

  local function score_pane(pane, current_path, current_session, current_window_index)
    return {
      same_session = pane.session_name == current_session,
      same_window = pane.window_index == current_window_index,
      path_score = common_prefix_len(pane.pane_current_path, current_path),
    }
  end

  local function sort_panes(panes, current_path, current_session, current_window_index)
    local sorted = {}
    for i, pane in ipairs(panes) do
      sorted[i] = pane
    end

    table.sort(sorted, function(a, b)
      local a_score = score_pane(a, current_path, current_session, current_window_index)
      local b_score = score_pane(b, current_path, current_session, current_window_index)

      if a_score.same_session ~= b_score.same_session then
        return a_score.same_session
      end

      if a_score.same_window ~= b_score.same_window then
        return a_score.same_window
      end

      if a_score.path_score == b_score.path_score then
        return a._index < b._index
      end
      return a_score.path_score > b_score.path_score
    end)

    return sorted
  end

  local function parse_tmux_info(line)
    local parts = vim.split(vim.trim(line), "%s+", { trimempty = true })
    return {
      current_path = parts[1],
      current_session = parts[2],
      current_window_index = parts[3],
    }
  end

  -- /home/mei/ghq/github.com/olimorris/codecompanion.nvim $4 1
  local tmux_current_stdout =
    vim.fn.system([[tmux display-message -p "#{pane_current_path} #{session_id} #{window_index}"]])

  local tmux_current = parse_tmux_info(tmux_current_stdout)

  local current_path = tmux_current.current_path
  local current_session = tmux_current.current_session
  local current_window_index = tmux_current.current_window_index

  local panes = parse_panes(tmux_list, fields)
  local sorted = sort_panes(panes, current_path, current_session, current_window_index)
  return sorted
end

--
--
-- local panes = list_tmux_pane_with_rank()
-- render_lines(panes)
--
return {
  list_tmux_pane_with_rank = list_tmux_pane_with_rank
}
