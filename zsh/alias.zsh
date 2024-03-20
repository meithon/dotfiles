# #!/bin/zsh
#
# abbrev-alias -g vi="nvim"
# abbrev-alias -g vv="~/dotfiles/nvim-switcher/switcher.sh"
# abbrev-alias -g lv="NVIM_APPNAME=LazyVim nvim"
#
# abbrev-alias -g ll="lsd -l"
# abbrev-alias -g la="lsd -l -a"
# abbrev-alias -g ..="cd .."
# abbrev-alias -g ...="cd ../../"
#
# abbrev-alias -g k="kubectl"
#
# ## node
# abbrev-alias -g pn="pnpm"
# abbrev-alias -g pnr="pnpm run"
# abbrev-alias -g pne="pnpm exec"
#
# ## git 
# abbrev-alias -g ga="git add"
# abbrev-alias -g gc="git commit"
# abbrev-alias -g gs="git status"
# abbrev-alias -g gsw="git switch"
# abbrev-alias -g grb="git rebase"
# abbrev-alias -g grs="git reset --soft HEAD^"
# abbrev-alias -g gtree="git tree"
# abbrev-alias -g git_rebase_main="git switch main && git pull && git switch - && git rebase main"
#
# abbrev-alias -g G="| rg --line-number"


function fzf-print-k8s-secret() {
  S=$(kubectl get secrets -o name | fzf) && echo $S && kubectl get $S -o json | jq '.data | map_values(@base64d)'
}

abbrev-alias ta="tmux attach"
abbrev-alias vd="neovide"

abbrev-alias vi="nvim"
abbrev-alias vv="~/dotfiles/nvim-switcher/switcher.sh"
abbrev-alias lv="NVIM_APPNAME=LazyVim nvim"
abbrev-alias av="NVIM_APPNAME=AstroVim nvim"

alias ksec=fzf-print-k8s-secret
alias ll="lsd -l"
alias la="lsd -l -a"
abbrev-alias ..="cd .."
abbrev-alias ...="cd ../../"

# one word
abbrev-alias k="kubectl"
abbrev-alias j="just"

## node
abbrev-alias pn="pnpm"
abbrev-alias pnr="pnpm run"
abbrev-alias pne="pnpm exec"

## git
abbrev-alias ga="git add"
abbrev-alias gc="git commit"
abbrev-alias gs="git status"
abbrev-alias gsw="git switch"
abbrev-alias grb="git rebase"
abbrev-alias grs="git reset"
abbrev-alias gitr="git tree"

abbrev-alias git-pretty-log="git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ad) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=format:'%Y-%m-%d %H:%M'"
abbrev-alias remain="git switch main && git pull && git switch - && git rebase main"

abbrev-alias -g G="| rg --line-number"

## mise
abbrev-alias mir="mise run"
alias mr="fzf-mise-run"
alias mie="fzf-mise-tasks-edit"

# pueue 
alias pf=pueue-follow-fzf
# 'pueue status --json | jq -r \'.tasks[] | " \(.id)  \(.command) "\' | fzf-tmux --preview \'echo {} | awk "{print \$1}" | xargs pueue follow\' | awk "{print \$1}"\'

function pueue-follow-fzf() {
  local tasks=$(pueue status --json | jq -r '.tasks[] | " \(.id)  \(.command) "')
  local selectedLine=$(echo $tasks | fzf-tmux --preview 'echo {} | awk "{print \$1}" | xargs pueue follow')
  local task_id=$(echo $selectedLine | awk '{print $1}')

  if [ -z $task_id ]; then
    return
  fi
  pueue follow $task_id
}

if command -v unbuffer >/dev/null 2>&1; then
    alias pueueaddbuffer='pueue add -- unbuffer'
fi


function fzf-mise-run() {
  TASK=$(mise tasks | fzf | awk '{print $1}') && echo -e Run tasks "\033[1;34m$TASK\033[0m" && mise run $TASK
}


function fzf-mise-tasks-edit() {
  TASK=$(mise tasks | fzf | awk '{print $NF}') && echo -e Run tasks "\033[1;34m$TASK\033[0m" && $EDITOR $TASK
}

# ghqとfzfを使用してディレクトリを変更する関数を定義
find-repository-and-move() {
  local repo=$(ghq list | fzf)
  cd ~/ghq/$repo
  echo moved to \"$repo\"
}

alias repos=find-repository-and-move
abbrev-alias -g rps='repos'


# docker 
# alias docker-fzf-stop="docker stop $(docker ps -a | tail -n +2 | fzf -m | awk '{print $1}')"
# alias docker-fzf-start="docker start $(docker ps -a | tail -n +2 | fzf -m | awk '{print $1}')"
# alias docker-fzf-valume-remove="docker volume rm -f $(docker volume ls | tail -n +2 | fzf -m | awk '{print $2}')"
#
# # stern
# alias stern-pod="stern $(kubectl get pods --output name| fzf) | tspin"
# abbrev-alias -g stp="stern-pod"
#
# # fzf
# abbrev-alias -g f="\$(fzf)"
# abbrev-alias -g s="\$("
#

# bun
# alias br="fzf-bun-run"
#
# function fzf-bun-run(){
#   SCRIPT=$(cat package.json | jq -r '.scripts | keys[]' |fzf)&& echo $SCRIPT && bun run $SCRIPT
# }

function depends_on () {
  for cmd in "$@"; do
    type "$cmd" >/dev/null 2>&1 || return 1
  done
}

depends_on rg && alias rg="rg --hidden --no-ignore-vcs --no-ignore --no-ignore-parent --smart-case --column --line-number --color=always --max-columns=1000 --max-columns-preview"

# Correct initialization of an associative array
# aliases=(
#   ["k"]="kubectl"
#   ["-docker-fzf-stop"]='docker stop $(docker ps -a | tail -n +2 | fzf -m | awk '"'"'{print $1}'"'"')'
#   ["-docker-fzf-start"]='docker start $(docker ps -a | tail -n +2 | fzf -m | awk  '"'"'{print $1}'"'"')'
# )
#
# for item in ${aliases[@]}; do
#     alias "$item=${aliases[$item]}"
# done

# Add a subcommand named tree to git
git() {
    if [[ $@ == "tree" ]]; then
        command git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ad) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=format:"%Y-%m-%d %H:%M"
    else
        command git "$@"
    fi
}



# # コマンドにカスタムサブコマンドを追加する関数
# add_custom_subcommand() {
#     local command_name="$1" # コマンド名
#     local subcommand_name="$2" # カスタムサブコマンド名
#     shift 2 # 最初の2つの引数を削除
#
#     # 関数を定義し、既存のコマンドにフックする
#     eval "
#     $command_name() {
#         if [[ \$1 == \"$subcommand_name\" ]]; then
#             shift # カスタムサブコマンド名を引数から削除
#             $@
#         else
#             command $command_name \"\$@\"
#         fi
#     }
#     "
# }
# add_custom_subcommand git tree git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ad) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=format:"%Y-%m-%d %H:%M"

# # 例: 'git' コマンドに 'tree' サブコマンドを追加
# add_custom_subcommand pueue add pueue-add
alias chrome='open /Applications/Google\ Chrome.app/'
