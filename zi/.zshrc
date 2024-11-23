# z4h init
# if [[ -z "${ISTERM}" && $- = *i* && $- != *c* ]]; then
#   if [[ -o login ]]; then
#     is -s zsh --login ; exit
#   else
#     is -s zsh ; exit
#   fi
# fi

source ~/dotfiles/zi/plugins.zsh
source ~/dotfiles/zi/config.zsh
#
source ~/dotfiles/shell/alias.sh
source ~/dotfiles/shell/asdf.sh
# source /Users/mei/.docker/init-zsh.sh || true # Added by Docker Desktop
#
#
# zinit light qoomon/zsh-lazyload
# lazyload kubecolor -- 'source <(kubectl completion zsh);compdef kubecolor="kubectl"'
# command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"


# [[ -f ~/.inshellisense/zsh/init.zsh ]] && source ~/.inshellisense/zsh/init.zsh

PATH=~/.console-ninja/.bin:$PATH
