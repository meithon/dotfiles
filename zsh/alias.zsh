alias vi="nvim"
alias ll="lsd -l"
alias la="lsd -l -a"
alias ..="cd .."
alias ...="cd ../../"

alias k="kubectl"

## node
alias pn="pnpm"
alias pnr="pnpm run"
alias pne="pnpm exec"

# Add a subcommand named tree to git
git() {
    if [[ $@ == "tree" ]]; then
        command git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    else
        command git "$@"
    fi
}

alias chrome='open /Applications/Google\ Chrome.app/'
