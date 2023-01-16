alias vi="nvim"
alias ll="lsd -l"
alias la="lsd -l -a"
alias ..="cd .."
alias ...="cd ../../"

# Add a subcommand named tree to git
git() {
    if [[ $@ == "tree" ]]; then
        command git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    else
        command git "$@"
    fi
}

alias fga="fzf-git-add"
alias fd='fzf-cdr'
alias fda='fzf-cdr-all'

alias chrome='open /Applications/Google\ Chrome.app/'
