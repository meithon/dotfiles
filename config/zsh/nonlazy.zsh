# Enable Powerlevel10k instant prompt. Should stay close to the top of ./.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ./.p10k.zsh.
[[ ! -f ./.p10k.zsh ]] || source ./.p10k.zsh

source ./options.zsh



function fzf-history-search() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ") CURSOR=$#BUFFER
}


bindkey -M viins '^v' per-directory-history-toggle-history
bindkey -M vicmd '^v' per-directory-history-toggle-history


zle -N fzf-history-search
bindkey -M viins '^r' fzf-history-search
bindkey -M vicmd '^r' fzf-history-search

source ./plugin/zsh-abbrev-alias.zsh
source ./plugin/fzf.zsh
source ./plugin/zoxide.zsh

