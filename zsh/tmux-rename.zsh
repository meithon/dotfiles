tmux-auto-rename() {
	# last execute command
	local last=$1
	tmux rename-window "$(pwd) $ $last  "
}

autoload -U add-zsh-hook
add-zsh-hook preexec tmux-auto-rename
