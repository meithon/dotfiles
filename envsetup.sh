export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

declare ASDF_DIR
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ASDF_DIR=$HOME/.asdf
elif [[ "$OSTYPE" == "darwin"* ]]; then
  ASDF_DIR=/opt/homebrew/opt/asdf/libexec/
  export PATH=/opt/homebrew/bin:$PATH
fi

. $ASDF_DIR/asdf.sh

export PATH=$(asdf where rust)/bin:$PATH
export PATH=$(asdf where golang)/packages/bin:$PATH
export JAVA_HOME=$(asdf where java)

alias vi="nvim"
alias ll="lsd -l"
