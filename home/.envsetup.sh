export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # in linux
  . "$HOME/.asdf/asdf.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # in mac
  export PATH=/opt/homebrew/bin:$PATH
fi
export PATH=$(asdf where rust)/bin:$PATH
export PATH=$(asdf where golang)/packages/bin:$PATH
export JAVA_HOME=$(asdf where java)

alias vi="nvim"
alias ll="lsd -l"
