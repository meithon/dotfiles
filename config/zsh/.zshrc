ZSHRC_DIR=${${(%):-%N}:A:h}

# overwrite
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}

# ensure_zcompiled ~/.zshrc

# sheldon cache technique
export SHELDON_CONFIG_DIR="$ZSHRC_DIR/sheldon"
sheldon_cache="$SHELDON_CONFIG_DIR/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml

# sync process
source $ZSHRC_DIR/nonlazy.zsh

# lazy process
zsh-defer source $ZSHRC_DIR/lazy.zsh
zsh-defer unfunction source

# for cmp-zsh.nvim
zmodload zsh/zpty




