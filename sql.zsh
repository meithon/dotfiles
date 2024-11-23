function fzf-sqlite-select() {
  local selected
  local query="
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where places.dir = '$(sql_escape $PWD)'
      group by commands.argv
      order by count(*) desc
  "
  local selected
  selected=$(
    _histdb_query -separator '\x1e' "$query" |
      bat --plain --language sql --color always |
      fzf --read0 --ansi --layout reverse \
        --preview 'echo {}' \
        --preview-window=up:3:wrap \
        --separator='\x1e' \
        --with-nth=1.. \
        --highlight-line
  )

  if [ -n "$selected" ]; then
    BUFFER="${selected}"
    CURSOR=$#BUFFER
  fi
}

zle -N fzf-sqlite-select
bindkey '^S' fzf-sqlite-select

_histdb_query -separator '\x1e' " 
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where places.dir = '$(sql_escape $PWD)'
      group by commands.argv
      order by count(*) desc
  "
