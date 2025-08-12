function tmux-auto-rename() {
	if [[ $TMUX = "" ]]; then
		return
	fi
	
	# Get the working directory of pane 1 (index 0) in the current window
	local pane1_path=$(tmux display-message -p -t 0 "#{pane_current_path}")
	local current_window=$(tmux display-message -p "#{window_id}")
	
	# Get all window paths and their base names
	local -A window_paths
	local -A basename_counts
	
	# Collect all window paths
	while IFS= read -r line; do
		local window_id=$(echo "$line" | cut -d: -f1)
		local window_path=$(echo "$line" | cut -d: -f2)
		window_paths[$window_id]="$window_path"
		local base_name=$(basename "$window_path")
		basename_counts[$base_name]=$((basename_counts[$base_name] + 1))
	done < <(tmux list-windows -F "#{window_id}:#{?#{==:#{window_panes},0},#{session_path},#{pane_current_path}}")
	
	# Determine the appropriate name for current window
	local base_name=$(basename "$pane1_path")
	local window_name="$base_name"
	
	# If there are duplicates, add minimal distinguishing path
	if [[ ${basename_counts[$base_name]} -gt 1 ]]; then
		local -a conflicting_paths
		for window_id in "${(@k)window_paths}"; do
			if [[ $(basename "${window_paths[$window_id]}") == "$base_name" ]]; then
				conflicting_paths+=("${window_paths[$window_id]}")
			fi
		done
		
		# Find minimal distinguishing suffix
		window_name=$(get_minimal_distinguishing_name "$pane1_path" "${conflicting_paths[@]}")
	fi
	
	tmux rename-window "$window_name"
}

# Helper function to get minimal distinguishing name
function get_minimal_distinguishing_name() {
	local target_path="$1"
	shift
	local conflicting_paths=("$@")
	
	local target_parts=(${(s:/:)target_path})
	local base_name=$(basename "$target_path")
	
	# Find the minimum number of parent directories needed to distinguish
	local max_depth=1
	
	# For each conflicting path, find how many levels we need to go up to distinguish
	for conflict_path in "${conflicting_paths[@]}"; do
		if [[ "$conflict_path" != "$target_path" ]]; then
			local conflict_parts=(${(s:/:)conflict_path})
			
			# Skip if the conflicting path doesn't end with the same basename
			if [[ $(basename "$conflict_path") != "$base_name" ]]; then
				continue
			fi
			
			# Find the first differing parent directory
			local depth=2
			local found_difference=false
			
			while [[ $depth -le ${#target_parts} ]] && [[ $depth -le ${#conflict_parts} ]]; do
				local target_part="${target_parts[-$depth]}"
				local conflict_part="${conflict_parts[-$depth]}"
				
				if [[ "$target_part" != "$conflict_part" ]]; then
					found_difference=true
					break
				fi
				depth=$((depth + 1))
			done
			
			# If we found a difference, we need at least this depth
			if $found_difference; then
				if [[ $depth > $max_depth ]]; then
					max_depth=$depth
				fi
			else
				# If no difference found in common depth, need the full distinguishable path
				max_depth=${#target_parts}
			fi
		fi
	done
	
	# Build the result with the minimum required depth
	if [[ $max_depth -eq 1 ]]; then
		echo "$base_name"
	else
		local result="${target_parts[-$max_depth]}"
		for ((i = max_depth-1; i >= 1; i--)); do
			result="$result/${target_parts[-$i]}"
		done
		echo "$result"
	fi
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
