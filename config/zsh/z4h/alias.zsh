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

function neogit() {
  nvim -c "Neogit" -c "autocmd TabClosed 2 quit"
}

function git_pr_commit_url() {
  local remote_url pr_num commit
  remote_url=$(git remote get-url origin)
  remote_url=${remote_url%.git}
  pr_num=$(gh pr view --json number --jq ".number")
  commit=$(git log --format=%H -n 1 HEAD)
  echo "${remote_url}/pull/${pr_num}/commits/${commit}"
}

git() {
  if [[ $@ == "tree" ]]; then
    command git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ad) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=format:"%Y-%m-%d %H:%M"
  else
    command git "$@"
  fi
}
