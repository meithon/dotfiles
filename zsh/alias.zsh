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


alias ta="tmux attach"
alias vd="neovide"

alias vi="nvim"
alias vv="~/dotfiles/nvim-switcher/switcher.sh"
alias lv="NVIM_APPNAME=LazyVim nvim"

alias ll="lsd -l"
alias la="lsd -l -a"
alias ..="cd .."
alias ...="cd ../../"

# one word
alias k="kubectl"
alias j="just"

## node
alias pn="pnpm"
alias pnr="pnpm run"
alias pne="pnpm exec"

## git
alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias gsw="git switch"
alias grb="git rebase"
alias grs="git reset --soft HEAD^"
alias gtree="git tree"
alias git_rebase_main="git switch main && git pull && git switch - && git rebase main"

alias -g G="| rg --line-number"


# ghqとfzfを使用してディレクトリを変更する関数を定義
find-repository-and-move() {
  cd ~/ghq/$(ghq list | fzf) && ls
}

# "repos"
abbrev-alias -g rps='find-repository-and-move'


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
        command git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    else
        command git "$@"
    fi
}

alias chrome='open /Applications/Google\ Chrome.app/'
