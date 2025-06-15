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
