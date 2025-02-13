# source ~/dotfiles/config/z4h/zshrc.mac.zsh
source ~/dotfiles/config/zsh/zinit/config.zsh
source ~/dotfiles/config/zsh/zinit/plugins.zsh

source ~/dotfiles/shell/alias.sh
source ~/dotfiles/shell/asdf.sh
# zsh-defer source ~/dotfiles/shell/envsetup.sh
source ~/dotfiles/shell/envsetup.sh


export PATH="$(go env GOPATH)/bin:$PATH"

find-repository-and-move() {
  local repo=$(ghq list | fzf)
  cd ~/ghq/$repo
  echo moved to \"$repo\"
}
alias repos=find-repository-and-move
alias -g rps='repos'
alias kx='kubectx'


fzf-git-cd() {
  local root_dir selected_dir
  # Gitリポジトリのルートを取得
  root_dir=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Not a git repository" >&2
    return 1
  }
  
  # リポジトリルート基準でディレクトリ選択
  selected_dir=$(git -C "$root_dir" ls-files -z | xargs -0 dirname | sort -u |
    fzf --height 40% --reverse --preview "tree -C '$root_dir/{}' | head -200")
  
  # 選択があれば移動
  if [ -n "$selected_dir" ]; then
    cd "$root_dir/$selected_dir" || return
  fi
}

alias ff=fzf-git-cd


function kn() {
  nvim -c 'lua require("boot").setup({theme={"melody"}})' -c 'lua require("kubectl").open()'
}

function ain() {
  nvim -c "CodeCompanionChat" -c "bdelete 1"
}

