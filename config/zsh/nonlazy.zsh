# Enable Powerlevel10k instant prompt. Should stay close to the top of ./.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ./.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source ./options.zsh



# source $ZSHRC_DIR/zinit/plugins.zsh
# source $ZSHRC_DIR/zinit/config.zsh
# source $ZSHRC_DIR/zinit/config.zsh
source $ZSHRC_DIR/plugin/histdb.zsh
source $ZSHRC_DIR/plugin/zoxide.zsh
source $ZSHRC_DIR/plugin/zsh-abbrev-alias.zsh
source $ZSHRC_DIR/plugin/zsh-vi-mode.zsh

source $ZSHRC_DIR/../../shell/alias.sh
source $ZSHRC_DIR/../../shell/asdf.sh


source <(kubectl completion zsh);compdef kubecolor="kubectl"
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"

