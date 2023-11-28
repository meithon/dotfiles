#!/bin/zsh

alias vi="nvim"
alias vv="~/dotfiles/nvim-switcher/switcher.sh"
alias lv="NVIM_APPNAME=LazyVim nvim"

alias ll="lsd -l"
alias la="lsd -l -a"
alias ..="cd .."
alias ...="cd ../../"

alias k="kubectl"

## node
alias pn="pnpm"
alias pnr="pnpm run"
alias pne="pnpm exec"

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
