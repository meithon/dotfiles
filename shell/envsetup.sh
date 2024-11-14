export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

add_path() {
  local suffix="${2:-}"
  local path=$(eval "$1")$suffix
  export PATH="$path:$PATH"
}

add_path 'asdf where rust' /bin
add_path 'asdf where golang' /packages/bin
add_path '' ~/.cargo/bin
export JAVA_HOME=$(asdf where java)
export PATH=$PATH:$(go env GOPATH)/bin
