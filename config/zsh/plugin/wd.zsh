function wd-exec() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: wd-exec <warp_point> <command> [args...]"
    return 1
  fi

  local point="$1"
  shift

  local target_dir
  target_dir=$(wd path "$point" 2>/dev/null)

  if [[ -z "$target_dir" ]]; then
    echo "Warp point '$point' not found."
    return 1
  fi

  if [[ ! -d "$target_dir" ]]; then
    echo "Directory '$target_dir' does not exist."
    return 1
  fi

  (
    cd "$target_dir" || return
    eval "$@"
  )
}

_wd_exec() {
  # 補完位置によって処理を分岐
  if [[ $CURRENT -eq 2 ]]; then
    # 第一引数の場合：ワープポイントを補完
    local -a warp_points
    warp_points=($(wd list 2>/dev/null | grep -v "All warp points" | awk '{print $1}'))
    compadd -a warp_points
  elif [[ $CURRENT -eq 3 ]]; then
    # 第二引数の場合：コマンド名を補完
    _command_names
  else
    # 第三引数以降：現在のコマンドの引数として通常の補完を使用
    local cmd=${words[3]}
    # カレントワードをシフトして、通常のコマンド補完として扱う
    words=("$cmd" "${words[4, -1]}")
    CURRENT=$((CURRENT - 2))
    _normal
  fi
}

# 補完を登録
compdef _wd_exec wd-exec

compdef _wd_exec wd-exec

alias we="wd-exec"
