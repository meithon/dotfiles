interactive-directory-search() {
  local dir=$(zoxide query --interactive)

  if [ -n "$dir" ]; then
    # BUFFER+="cd $dir"
    cd "$dir"
    zle reset-prompt
  else
    return 1
  fi
}

add-zsh-hook precmd __bind-interactive-directory-search

function __bind-interactive-directory-search() {
  zle -N interactive-directory-search
  bindkey -M viins '^g' interactive-directory-search
  bindkey -M vicmd '^g' interactive-directory-search
  bindkey '^g' interactive-directory-search
}

interactive-directory-tmux() {
  local dir=$(zoxide query --interactive)

  if [ -n "$dir" ]; then
    local session_name=$(basename "$dir" | tr '.' '_')

    # セッションの存在確認
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      # セッションが存在しない場合、新規作成
      tmux new-session -d -s "$session_name" -c "$dir"
    fi

    if [ -z "$TMUX" ]; then
      # TMUX外からの実行
      BUFFER="tmux attach -t $session_name"
    else
      # TMUX内からの実行
      BUFFER="tmux switch-client -t $session_name"
    fi
    zle accept-line
  else
    return 1
  fi
}

# これを指定すると下部に固定される
export _ZO_FZF_OPTS="--layout=default"

zle -N interactive-directory-tmux

# キーバインドの設定例（Ctrl+G）
bindkey '^G' interactive-directory-tmux

eval "$(zoxide init zsh)"
