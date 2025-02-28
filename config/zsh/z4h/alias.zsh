z4h source ~/dotfiles/shell/alias.sh

# TODO: 適切な場所に移動する
function pueue-follow-fzf() {
  local tasks=$(pueue status --json | jq -r '.tasks[] | " \(.id)  \(.command) "')
  local selectedLine=$(echo $tasks | fzf-tmux --preview 'echo {} | awk "{print \$1}" | xargs pueue follow')
  local task_id=$(echo $selectedLine | awk '{print $1}')

  if [ -z $task_id ]; then
    return
  fi
  pueue follow $task_id
}

# pueue
alias pf=pueue-follow-fzf
