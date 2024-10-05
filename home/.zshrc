# timer=$(($(gdate +%s%N)/1000000))
# # I use gdate from brew's core-utils because macOS date does not support nanoseconds
# # must load before zsh config


_main() {
  eval "$(sheldon source)"
  setup_p10k
  zsh-defer setup_tools
  zsh-defer -m load_zsh_configs
  setup_bun_completion 
  source /Users/mei/.docker/init-zsh.sh || true # Added by Docker Desktop
  setup_brew_completion
  zsh-defer source ~/.envsetup.sh
}

setup_p10k() {
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  [[ ! -f ~/.p10k.zsh ]] ||  source ~/.p10k.zsh
}

ZSHHOME="${HOME}/dotfiles/zsh"

# Function to check if a file is a readable .zsh file or symlink
is_readable_zsh_file() {
    local file=$1
    [[ -r "$file" && "${file##*/}" == *.zsh && ( -f "$file" || -h "$file" ) ]]
}

# Load zsh configs if ZSHHOME is a readable and executable directory
load_zsh_configs() {
  if [[ -d "$ZSHHOME" && -r "$ZSHHOME" && -x "$ZSHHOME" ]]; then
      for file in "$ZSHHOME"/*.zsh; do
          if is_readable_zsh_file "$file"; then
              zsh-defer source "$file"
          fi
      done
  fi
}

setup_tools() {
  # eval "$(starship init zsh)"
  eval $(thefuck --alias fk)
  eval "$(direnv hook zsh)"
  eval "$(zoxide init zsh)"
}

# bun completions
setup_bun_completion() {
  [ -s "/Users/mei/.bun/_bun" ] && source "/Users/mei/.bun/_bun"
}
#
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export EDITOR=nvim
export K9S_EDITOR=nvim

setup_brew_completion() {
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
}

PATH=~/.console-ninja/.bin:$PATH

<<<<<<< HEAD


<<<<<<< HEAD
### Added by Codeium. These lines cannot be automatically removed if modified
if command -v termium > /dev/null 2>&1; then
  eval "$(termium shell-hook show post)"
fi
### End of Codeium integration
=======

source <(argo completion zsh)
=======
>>>>>>> 6fd57af (some)
export ARGO_SERVER='***REMOVED***' 
export ARGO_HTTP1=true  
export ARGO_SECURE=true
export ARGO_BASE_HREF=
export ARGO_NAMESPACE=build-workflows
<<<<<<< HEAD
>>>>>>> ed9ed10 (some)
=======


_main
# now=$(($(gdate +%s%N)/1000000))
# elapsed=$(($now-$timer))
# echo $elapsed ms
>>>>>>> 6fd57af (some)
