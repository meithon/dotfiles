# typeset -A ZI
# ZI[BIN_DIR]="${HOME}/.zi/bin"
# source "${ZI[BIN_DIR]}/zi.zsh"
# autoload -Uz _zi
# (( ${+_comps} )) && _comps[zi]=_zi
# timer=$(($(gdate +%s%N)/1000000))
# # I use gdate from brew's core-utils because macOS date does not support nanoseconds
# # must load before zsh config


_main() {
  eval "$(sheldon source)"
  setup_p10k
  zsh-defer setup_tools
  # do no use zsh-defer, bug: not set HIST env
  load_zsh_configs 
  setup_bun_completion 
  source /Users/mei/.docker/init-zsh.sh || true # Added by Docker Desktop
  setup_brew_completion
  . ~/dotfiles/shell/alias.sh
  . ~/dotfiles/shell/asdf.sh
  source ~/dotfiles/shell/envsetup.sh
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
              source "$file"
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

### Added by Codeium. These lines cannot be automatically removed if modified
if command -v termium > /dev/null 2>&1; then
  eval "$(termium shell-hook show post)"
fi
### End of Codeium integration

_main
# now=$(($(gdate +%s%N)/1000000))
# elapsed=$(($now-$timer))
# echo $elapsed ms

# Created by `pipx` on 2024-09-12 01:05:40
export PATH="$PATH:/Users/mei/.local/bin"

# pnpm
export PNPM_HOME="/Users/mei/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
eval "$(argo completion zsh)"


######################################################################
#              _ __                   _____                          #
#       ____ _(_) /__________  ____  / __(_)___ ____  ____ _   __    #
#      / __ `/ / __/ ___/ __ \/ __ \/ /_/ / __ `/ _ \/ __ \ | / /    #
#     / /_/ / / /_/ /__/ /_/ / / / / __/ / /_/ /  __/ / / / |/ /     #
#     \__, /_/\__/\___/\____/_/ /_/_/ /_/\__, /\___/_/ /_/|___/      #
#    /____/                             /____/                       #
######################################################################
function gitconfig_chpwd() {
  local work_dir="${HOME}/workspace/work"

  old_git_config=$GIT_CONFIG_GLOBAL

  if [[ "$PWD" == "$work_dir"* ]]; then
    export GIT_CONFIG_GLOBAL="${work_dir}/.gitconfig"
    if [[ $old_git_config != $GIT_CONFIG_GLOBAL ]] {
      echo "GIT_CONFIG_GLOBAL set to ${work_dir}/.gitconfig"
    }
  else
    unset GIT_CONFIG_GLOBAL
    if [[ $old_git_config != $GIT_CONFIG_GLOBAL ]] {
      echo "GIT_CONFIG_GLOBAL unset"
    }
  fi
}

# chpwd フックに新しい関数を追加
autoload -U add-zsh-hook
add-zsh-hook chpwd gitconfig_chpwd

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/mei/.config/.dart-cli-completion/zsh-config.zsh ]] && . /Users/mei/.config/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

