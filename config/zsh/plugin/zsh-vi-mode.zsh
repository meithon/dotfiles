get_word_start_and_end() {
  local buffer=$1
  local column=$2
  local positions=()
  local ends=()
  local current_pos=0

  # Collect word positions
  while [[ $current_pos -lt ${#buffer} ]]; do
    # Skip spaces
    while [[ "${buffer:$current_pos:1}" == " " && $current_pos -lt ${#buffer} ]]; do
      ((current_pos++))
    done

    if [[ $current_pos -lt ${#buffer} ]]; then
      positions+=($current_pos)

      local word_end=$current_pos
      while [[ "${buffer:$word_end:1}" != " " && $word_end -lt ${#buffer} ]]; do
        ((word_end++))
      done
      ends+=($((word_end - 1)))
    fi

    current_pos=$((word_end + 1))
  done

  # Return positions for the requested column (adjusting for 1-based indexing)
  if [[ $column -le ${#positions[@]} ]]; then
    echo "${positions[$column]} ${ends[$column]}"
  else
    echo "-1 -1"
  fi
}

function zvm_select_sub_command() {
  local poss=($(get_word_start_and_end "$BUFFER" 2))

  if [[ ${#poss[@]} -eq 2 && $poss[1] != -1 ]]; then
    local start=$poss[1]
    local end=$poss[2]

    CURSOR=$start
    zvm_enter_visual_mode v
    CURSOR=$end
  fi
}

zle -N zvm_select_sub_command
bindkey -M vicmd 's' zvm_select_sub_command

zvm_define_widget file_search
zvm_bindkey vicmd ' ff' file_search # または別のキーバインディング

function file_search() {
  # fd があれば使用、なければ find を使用
  local result
  if (($ + commands[fd])); then
    result=$(fd --type f | fzf)
  else
    result=$(find . -type f | fzf)
  fi

  # 結果が空でない場合、コマンドラインに挿入
  if [[ -n "$result" ]]; then
    BUFFER="$BUFFER$result"
    CURSOR=$#BUFFER
  fi

  zle reset-prompt
}

zvm_define_widget find_git_directory
zvm_bindkey vicmd ' fd' find_git_directory # または別のキーバインディング

find_git_directory() {
  local root_dir selected_dir
  # Gitリポジトリのルートを取得
  root_dir=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Not a git repository" >&2
    return 1
  }

  # リポジトリルート基準でディレクトリ選択
  selected_dir=$(git -C "$root_dir" ls-files -z | xargs -0 dirname | sort -u |
    fzf --height 40% --reverse --preview "tree -C '$root_dir/{}' | head -200")

  # 選択があれば移動
  if [ -n "$selected_dir" ]; then
    cd "$root_dir/$selected_dir" || return
    zle accept-line
  fi
}

zvm_define_widget neogit
zvm_bindkey vicmd 'gh' neogit # または別のキーバインディング

function neogit() {
  nvim -c "Neogit" -c "autocmd TabClosed 2 quit"
}
