# source ~/dotfiles/config/z4h/zshrc.mac.zsh
source ~/dotfiles/config/zsh/zinit/config.zsh
source ~/dotfiles/config/zsh/zinit/plugins.zsh

source ~/dotfiles/shell/alias.sh
source ~/dotfiles/shell/asdf.sh
zsh-defer source ~/dotfiles/shell/envsetup.sh

find-repository-and-move() {
  local repo=$(ghq list | fzf)
  cd ~/ghq/$repo
  echo moved to \"$repo\"
}
alias repos=find-repository-and-move
alias -g rps='repos'

