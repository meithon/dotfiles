function tmux-switch() {
  RELOAD_CMD='tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_id}"'

  eval "$RELOAD_CMD" |
    fzf-tmux -p \
      --layout=reverse \
      --preview 'tmux capture-pane -pe -t {2}' \
      -w 60% \
      -h 80% \
      --border \
      --preview-window up:90% \
      --bind "ctrl-x:execute(tmux kill-pane -t {2}; $RELOAD_CMD > /dev/tty)+reload($RELOAD_CMD)" |
    awk '{print $2}' | xargs tmux switch-client -t
}
zle -N tmux-switch
bindkey '^j' tmux-switch

# +-------------------------+
# |        Window 1         |
# | +----------+----------+ |
# | |  Pane 1  |  Pane 2  | |
# | |          |          | |
# | +----------+----------+ |
# | |        Pane 3       | |
# | |                    | |
# | +--------------------+ |
# +-------------------------+
#
# +-------------------------------+
# |          Session 1            |
# | +---------+   +---------+     |
# | | Window 1|   | Window 2| ... |
# | +---------+   +---------+     |
# |                               |
# +-------------------------------+
#
