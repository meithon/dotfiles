function fzf-history-search() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}

add-zsh-hook precmd __bind_history_search

function __bind_history_search() {
  zle -N fzf-history-search
  bindkey '^r' fzf-history-search
  bindkey -M viins '^r' fzf-history-search
  bindkey -M vicmd '^r' fzf-history-search
}
