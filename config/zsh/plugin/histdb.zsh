_zsh_autosuggest_strategy_histdb_top() {
  local query="
    select commands.argv from history
    left join commands on history.command_id = commands.rowid
    left join places on history.place_id = places.rowid
    where commands.argv LIKE '$(sql_escape $1)%'
    group by commands.argv, places.dir
    order by places.dir != '$(sql_escape $PWD)', count(*) desc
    limit 1
  "
  suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top

_per_directory_history_is_global=0

per-directory-history-toggle-history() {
  # グローバル変数の初期化
  if [[ -z "$_per_directory_history_is_global" ]]; then
    _per_directory_history_is_global=0
  fi

  # 現在のディレクトリのヒストリーファイル
  local directory_history_file="${HOME}/.zsh_history_${PWD//\//_}"

  if [[ $_per_directory_history_is_global -eq 0 ]]; then
    # ローカル→グローバル切り替え
    _per_directory_history_is_global=1
    local msg="📝 History Mode: Global"
  else
    # Switch from global to directory-specific history
    _per_directory_history_is_global=0
    local msg="📂 History Mode: Directory-specific"
  fi

  print "$msg"
  print
  zle reset-prompt
}

zle -N per-directory-history-toggle-history
bindkey -M vicmd '^v' per-directory-history-toggle-history
bindkey -M viins '^v' per-directory-history-toggle-history

function search_history() {
  local sql_query
  if [[ -z "$_per_directory_history_is_global" ]] || [[ $_per_directory_history_is_global -eq 1 ]]; then
    sql_query="
      SELECT commands.argv 
      FROM commands 
      INNER JOIN history ON history.command_id = commands.rowid
      WHERE commands.argv != ''
      GROUP BY commands.argv
      ORDER BY MAX(history.start_time) DESC, COUNT(*) DESC
    "
  else
    sql_query="
      WITH filtered_places AS (
        SELECT rowid AS place_rowid
        FROM places
        WHERE dir = '$(sql_escape $PWD)'
      ),
      filtered_history AS (
        SELECT
          command_id,
          MAX(start_time) AS max_time,
          COUNT(*) AS cnt
        FROM history
        WHERE place_id IN (SELECT place_rowid FROM filtered_places)
        GROUP BY command_id
      )
      SELECT commands.argv
      FROM filtered_history
      JOIN commands ON commands.rowid = filtered_history.command_id
      WHERE commands.argv != ''
      ORDER BY filtered_history.max_time DESC, filtered_history.cnt DESC
    "
  fi

  local fzf_preview_cmd='echo {}| syncat -l bash'

  # 配列を使用する方法
  local -a fzf_opts=(
    --query="$BUFFER"
    --read0
    --ansi
    --layout=reverse
    --no-sort
    --height=40%
    --highlight-line
    --tiebreak=chunk,length,index
    --preview='echo {}| syncat -l bash'
    --preview-window=down:20%:wrap
    --prompt='History > '
    --header='[CTRL-Y:copy, CTRL-R:execute, ESC:exit]'
    --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)+abort'
    --bind 'ctrl-r:execute(echo {} | sh)+abort'
    --bind 'ctrl-v:execute(per-directory-history-toggle-history)'
    --bind 'esc:abort'
    --bind 'ctrl-/:toggle-preview'
    --color='header:italic:underline'
  )

  # local selected_command=$(
  #   _histdb_query -line "$sql_query" |
  #     grep '^argv = ' |
  #     sed 's/^argv = //' |
  #     grep -v '^$' |
  #     fzf "${fzf_opts[@]}"
  # )
  # local history_data="$(
  #   _histdb_query -json "$sql_query"
  # )"
  # local processed_data
  # processed_data=$(
  #   jq -j '.[].argv | gsub("\n$";"") + "\u0000"' <<<"$history_data" |
  #     perl -pe 's/\x00/;\n\x1E/g' |
  #     perl -pe 's/\x1E//' |
  #     syncat --language bash |
  #     perl -0777 -pe 's/;\n+/\x00/g'
  # )
  #
  # local selected_command="$(echo "$processed_data" | fzf "${fzf_opts[@]}")"
  #
  # PERF: stream processing
  local selected_command=$(_histdb_query -json "$sql_query" |
    jq -r '.[]|.argv + "\u0000"' |
    perl -pe 's/\x00/;\n/g' |
    syncat --language bash |
    perl -pe 's/;\n+/\x00/g' |
    fzf "${fzf_opts[@]}")

  BUFFER=$(echo $selected_command)
  CURSOR=$#BUFFER
}

zle -N search_history
function zvm_after_init() {
  bindkey '^R' search_history
  bindkey -M vicmd '^R' search_history
  bindkey -M viins '^R' search_history
}
unsetopt HIST_REDUCE_BLANKS # 空白の削除を無効化（改行を保持したい場合）

typeset -g HISTDB_ISEARCH_INPUT
typeset -g HISTDB_ISEARCH_N
typeset -g HISTDB_ISEARCH_MATCH

# TODO Underlining the match string
# TODO Fill out the keymap properly
# TODO Show more info about match (n, date, pwd, host)
# TODO Accept match and exit
# TODO Keys to switch to dir
# TODO Keys to limit match?

# make a keymap for histdb isearch
bindkey -N histdb-isearch main

_histdb_isearch_query() {
  if [[ -z $HISTDB_ISEARCH_INPUT ]]; then
    HISTDB_ISEARCH_MATCH=""
    return
  fi
  local query="select commands.argv from history left join commands
on history.command_id = commands.rowid
where commands.argv like '%$(sql_escape ${HISTDB_ISEARCH_INPUT})%'
order by history.rowid desc
limit 1
offset ${HISTDB_ISEARCH_N}"
  HISTDB_ISEARCH_MATCH=$(_histdb_query "$query")
}

_histdb_isearch_display() {
  BUFFER="${HISTDB_ISEARCH_MATCH}"
  POSTDISPLAY="
histdb: ${HISTDB_ISEARCH_INPUT} "
}

# define a self-insert command for it (requires other code)
self-insert-histdb-isearch() {
  HISTDB_ISEARCH_INPUT="${HISTDB_ISEARCH_INPUT}${KEYS}"
  _histdb_isearch_query
  _histdb_isearch_display
}

zle -N self-insert-histdb-isearch

_histdb-isearch() {
  HISTDB_ISEARCH_INPUT="${BUFFER}"
  HISTDB_ISEARCH_N=0
  BUFFER=""
  zle -K histdb-isearch
  _histdb_isearch_query
  _histdb_isearch_display
}

zle -N _histdb-isearch

bindkey '^R' _histdb-isearch

# ctrl-d:execute(source ~/.zinit/plugins/larkery---zsh-histdb/sqlite-history.zsh && histdb --forget {}
