function tmux-auto-rename() {
	# last execute command
	local last=$1
	# local path$(tmux "#{session_path}")
	# local path=$(relative-current-dir-for-tmux)
	# local name="$path $last"
	if [[ $TMUX = "" ]]; then
		return
	fi
	tmux rename-window $(relative-path $(tmux display-message -p "#{session_path}") "$(pwd)")" $last"
}

autoload -U add-zsh-hook
add-zsh-hook preexec tmux-auto-rename

# #it used by tmux.conf
relative-path () {
	source=$1
	target=$2

	common_part=$source
	back=
	while [ "${target#$common_part}" = "${target}" ]; do
		common_part=$(dirname $common_part)
		back="../${back}"
	done

	echo ${back}${target#$common_part/}
}
get-path-from-tmux-status() {
	arg="$1"
	echo "$arg" | sed -E 's@^(/[^[:space:]]+).*@\1@'
}

tmux() {
    if [ "$#" -eq 0 ]; then
        command tmux new -s "$(pwd)"
    else
        command tmux "$@"
    fi
}
