last_history_argument() {
  history | tail -n 1 | awk '{print $NF}'
}

abbrev-alias -g -e 'it=$(last_history_argument)'
abbrev-alias -g foreach="xargs -I{} "
