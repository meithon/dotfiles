interactive-directory-search() {
    local dir=$(zoxide query --interactive)

    if [ -n "$dir" ]; then
        BUFFER+="cd $dir"
        zle accept-line
    else
        return 1
    fi
}

add-zsh-hook precmd __bind-interactive-directory-search

function __bind-interactive-directory-search() {
  zle -N interactive-directory-search
  bindkey -M viins '^g' interactive-directory-search
  bindkey -M vicmd '^g' interactive-directory-search
}
