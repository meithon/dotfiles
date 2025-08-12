#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Configuration
DOTPATH="$HOME/dotfiles"
DOTFILES_GITHUB="https://github.com/MeiWagatsuma/dotfiles"
FORCE=false

usage() {
  cat <<EOF
Usage: $0 [-y] [-h]

Options:
  -y    Automatic yes to prompts (no confirmation)
  -h    Show this help message
EOF
  exit 1
}

parse_args() {
  while getopts "yh" opt; do
    case $opt in
      y) FORCE=true ;;
      h) usage     ;;
      *) usage     ;;
    esac
  done
  shift $((OPTIND -1))
}

# Color setup
if command -v tput &>/dev/null && [ -t 1 ]; then
  ncolors=$(tput colors 2>/dev/null || echo 0)
  if [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"   GREEN="$(tput setaf 2)"   YELLOW="$(tput setaf 3)"
    BOLD="$(tput bold)"     NORMAL="$(tput sgr0)"
  else
    RED="" GREEN="" YELLOW="" BOLD="" NORMAL=""
  fi
else
  RED="" GREEN="" YELLOW="" BOLD="" NORMAL=""
fi

# Logging helpers
info()  { printf "%s[+] %s%s
" "$GREEN" "$1" "$NORMAL"; }
warn()  { printf "%s[*] %s%s
" "$YELLOW" "$1" "$NORMAL"; }
error() { printf "%s[-] %s%s
" "$RED" "$1" "$NORMAL"; }
link() {
  if [ ! -e "$1" ]; then
    warn "$1 does not exist."
    return 1
  fi

  mkdir -p "$(dirname "$2")"
  ln -sfn "$1" "$2"
  info "Linked $2 → $1"
}

## @func confirm
#  Prompt the user to confirm the installation unless forced with -y.

confirm() {
  [ "$FORCE" = true ] && return
  read -rp "${YELLOW}[*] Proceed with installation? [y/N] ${NORMAL}" ans
  [[ "$ans" =~ ^[Yy]$ ]] || { error "Aborted."; exit 1; }
}

## @func clone_dotfiles
#  Clone the dotfiles repository into DOTPATH if it does not already exist.
clone_dotfiles() {
  if [ -d "$DOTPATH" ]; then
    warn "Dotfiles already present at $DOTPATH"
    return
  fi
  command -v git &>/dev/null || { error "git is required."; exit 1; }
  info "Cloning dotfiles into $DOTPATH"
  git clone "$DOTFILES_GITHUB" "$DOTPATH"
}

## @func deploy_dotfiles
#  Create symlinks for hooks, home dotfiles, and ~/.config entries.
deploy_dotfiles() {
  info "Deploying dotfiles"
  [ -d "$DOTPATH" ] || { error "$DOTPATH not found"; exit 1; }
  link "$DOTPATH/pre-commit" "$DOTPATH/.git/hooks/pre-commit"
  
  # Link files in home directory, recursively handling directories
  find "$DOTPATH/home" -type f | while read -r src; do
    # Remove the home/ prefix to get relative path
    rel_path="${src#$DOTPATH/home/}"
    dest="$HOME/$rel_path"
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    link "$src" "$dest"
  done
  
  for src in "$DOTPATH/config"/*; do
    base=$(basename "$src")
    link "$src" "$HOME/.config/$base"
  done
}

deploy_secrets() {
  link ~/dotfiles/secrets/.zshsecrets ~/.zshsecrets
}

## @func install_apt
#  Install development packages on Debian/Ubuntu systems via apt and apt-fast.
install_apt() {
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y ppa:apt-fast/stable
  sudo apt-get update
  sudo apt-get install -y apt-fast
  apt-fast install -y curl git btop zsh tmux jq fzf vim gh ripgrep bat gcc unzip make pkg-config libssl-dev
}

install_apk() {
  sudo apk update
  sudo apk add curl git btop zsh tmux jq fzf vim gh ripgrep bat gcc unzip make pkg-config openssl
}

## @func install_brew
#  Install packages on macOS using Homebrew.
install_brew() {
  command -v brew &>/dev/null || { error "Homebrew not found. Install it first."; exit 1; }
  brew update
  brew install curl git btop zsh tmux jq fzf ripgrep bat gcc unzip make pkg-config asdf
}

## @func install_termux
#  Install packages on Termux (Android) environment.
install_termux() {
  pkg update -y
  pkg upgrade -y
  pkg install -y curl git btop zsh tmux jq fzf ripgrep bat clang make pkg-config openssl unzip
}

## @func install_tools
#  Detect OS and install required development tools; ensure asdf is installed.
install_tools() {
  info "Installing tools for OS: $OSTYPE"
  if [[ "$OSTYPE" == linux-gnu* ]]; then
    install_apt
  elif [[ "$OSTYPE" == linux-musl* ]]; then
    install_apk
  elif [[ "$OSTYPE" == darwin* ]]; then
    install_brew
  elif [ -n "${TERMUX_VERSION-+x}" ]; then
    install_termux
  else
    error "Unsupported OS: $OSTYPE"; exit 1
  fi
  if [ ! -d "$HOME/.asdf" ]; then
    info "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.0
  fi
}

## @func setup_asdf
#  Add language plugins and install global versions via asdf.
setup_asdf() {
  info "Configuring asdf plugins"
  for lang in deno golang nodejs python rust; do
    asdf plugin-add "$lang" 2>/dev/null || true
    asdf install "$lang" latest
    asdf global "$lang" latest
  done
  asdf plugin-add java 2>/dev/null || true
  asdf install java openjdk-21.0.2
  asdf global java openjdk-21.0.2
}

## @func setup_rust
#  Set the Rust toolchain to stable and install useful Rust-based CLI tools.
setup_rust() {
  info "Configuring Rust"
  rustup default stable
  cargo install lsd sheldon bob-nvim pueue
  bob use latest
}

## @func main
#  Orchestrate parsing args, cloning, deploying, installing, and final configuration.
## @func main
#  Orchestrate parsing args, cloning, deploying, installing, and final configuration.
main() {
  parse_args "$@"
  printf "%s" "$BOLD"
  cat <<'EOF'
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝

  *** WHAT IS INSIDE? ***
  1. Clone your dotfiles from $DOTFILES_GITHUB
  2. Install development packages
  3. Symlink config files to your home directory

  *** HOW TO INSTALL? ***
  Read the README.md for details.
  Licensed under MIT.
EOF
  printf "%s" "$NORMAL"

  confirm
  clone_dotfiles
  deploy_dotfiles
  install_tools
  source "$HOME/dotfiles/shell/asdf.sh"
  setup_asdf
  source "$HOME/dotfiles/shell/envsetup.sh"
  setup_rust
  source "$HOME/dotfiles/shell/alias.sh"
  info "Installation complete!"
}

parse_args "$@"
main "$@"
