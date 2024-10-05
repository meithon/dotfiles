export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export JAVA_HOME=$(asdf where java)
# must load before zsh config
eval "$(sheldon source)"

### Added by Codeium. These lines cannot be automatically removed if modified
if command -v termium > /dev/null 2>&1; then
  eval "$(termium shell-hook show pre)"
fi
### End of Codeium integration



# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


ZSHHOME="${HOME}/dotfiles/zsh"

# load zsh configs
if [ -d $ZSHHOME -a -r $ZSHHOME -a \
  -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi


# eval "$(starship init zsh)"
eval $(thefuck --alias fk)
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

# bun completions
[ -s "/Users/mei/.bun/_bun" ] && source "/Users/mei/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export EDITOR=nvim
export K9S_EDITOR=nvim

# pnpm
export PNPM_HOME="/Users/mei/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
source /Users/mei/.docker/init-zsh.sh || true # Added by Docker Desktop

# enable completions of homebrew
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi



. /opt/homebrew/opt/asdf/libexec/asdf.sh

PATH=~/.console-ninja/.bin:$PATH



<<<<<<< HEAD
### Added by Codeium. These lines cannot be automatically removed if modified
if command -v termium > /dev/null 2>&1; then
  eval "$(termium shell-hook show post)"
fi
### End of Codeium integration
=======

source <(argo completion zsh)
export ARGO_SERVER='***REMOVED***' 
export ARGO_HTTP1=true  
export ARGO_SECURE=true
export ARGO_BASE_HREF=
export ARGO_NAMESPACE=build-workflows
>>>>>>> ed9ed10 (some)
