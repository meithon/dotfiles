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
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      where commands.argv != ''
      group by commands.argv
      order by max(history.start_time) desc, count(*) desc
    "
  else
    # グローバル履歴から検索
    sql_query="
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where places.dir = '$(sql_escape $PWD)'
        and commands.argv != ''
      group by commands.argv
      order by max(history.start_time) desc, count(*) desc
    "
  fi

  local fzf_preview_cmd='echo {}| syncat -l bash'
  
  # 配列を使用する方法
  local -a fzf_opts=(
      --read0
      --ansi
      --layout=reverse
      --no-sort
      --height=60%
      --highlight-line
      --preview='echo {}| syncat -l bash'
      --preview-window=right:50%:wrap
      --prompt='History > '
      --header='[CTRL-Y:copy, CTRL-R:execute, ESC:exit]'
      --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)+abort'
      --bind 'ctrl-r:execute(echo {} | sh)+abort'
      --bind 'ctrl-v:execute(per-directory-history-toggle-history)'
      --bind 'esc:abort'
      --bind 'ctrl-/:toggle-preview'
      --color='header:italic:underline'
  )


  local history_data="$(
    _histdb_query -json "$sql_query"
  )"
  local processed_data
  processed_data=$(
    jq -j '.[].argv | gsub("\n$";"") + "\u0000"' <<<"$history_data" | \
    perl -pe 's/\x00/;\n\x1E/g' |  \
    perl -pe 's/\x1E$//' | \
    syncat --language bash | \
    perl -0777 -pe 's/;\n+/\x00/g'
  )

  local selected_command="$(echo "$processed_data" | fzf "${fzf_opts[@]}")"

  BUFFER=$(echo $selected_command)
  CURSOR=$#BUFFER
}

zle -N search_history
bindkey '^R' search_history
bindkey -M vicmd '^R' search_history
bindkey -M viins '^R' search_history
unsetopt HIST_REDUCE_BLANKS      # 空白の削除を無効化（改行を保持したい場合）
