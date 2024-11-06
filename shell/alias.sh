alias ta="tmux attach"
alias vd="neovide"

alias vi="nvim"
alias vv="~/dotfiles/nvim-switcher/switcher.sh"
alias lv="NVIM_APPNAME=LazyVim nvim"
alias av="NVIM_APPNAME=AstroVim nvim"

alias ksec=fzf-print-k8s-secret
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
alias gph="git push"
alias gll="git pull"
alias gsw="git switch"
alias grb="git rebase"
alias grs="git reset"
alias gitr="git tree"

alias git-pretty-log="git log --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ad) -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --commit --date=format:'%Y-%m-%d %H:%M'"
alias remain="git switch main && git pull && git switch - && git rebase main"

## mise
alias mir="mise run"
alias mr="fzf-mise-run"
alias mie="fzf-mise-tasks-edit"

alias ka="kubectl-attach"

alias tf="terraform"

alias docker-attach-last='docker run -it --rm $(docker images -aq | head -n1)'

viob() {
  local inbox_dir="$HOME/Documents/obsidian-vault/Inbox"
  local note_name="$1"

  if [ -z "$note_name" ]; then
    echo "エラー: note名を指定してください。"
    echo "使用方法: viob <note名>"
    return 1
  fi

  # .md拡張子がない場合は追加
  if [[ "$note_name" != *.md ]]; then
    note_name="${note_name}.md"
  fi
  vi "$inbox_dir/$note_name"
}
