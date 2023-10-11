#!/bin/bash
tmux switch -t "$(tmux lsp -a -F "#{session_name}:#{window_name}" | fzf-tmux --preview 'tmux capture-pane -pe -t {}')"
