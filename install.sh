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
    h) usage ;;
    *) usage ;;
    esac
  done
  shift $((OPTIND - 1))
}

# Color setup
if command -v tput &>/dev/null && [ -t 1 ]; then
  ncolors=$(tput colors 2>/dev/null || echo 0)
  if [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)" GREEN="$(tput setaf 2)" YELLOW="$(tput setaf 3)"
    BOLD="$(tput bold)" NORMAL="$(tput sgr0)"
  else
    RED="" GREEN="" YELLOW="" BOLD="" NORMAL=""
  fi
else
  RED="" GREEN="" YELLOW="" BOLD="" NORMAL=""
fi

# Logging helpers
info() { printf "%s[+] %s%s
" "$GREEN" "$1" "$NORMAL"; }
warn() { printf "%s[*] %s%s
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
  [[ "$ans" =~ ^[Yy]$ ]] || {
    error "Aborted."
    exit 1
  }
}

## @func clone_dotfiles
#  Clone the dotfiles repository into DOTPATH if it does not already exist.
clone_dotfiles() {
  if [ -d "$DOTPATH" ]; then
    warn "Dotfiles already present at $DOTPATH"
    return
  fi
  command -v git &>/dev/null || {
    error "git is required."
    exit 1
  }
  info "Cloning dotfiles into $DOTPATH"
  git clone "$DOTFILES_GITHUB" "$DOTPATH"
}

## @func deploy_dotfiles
#  Create symlinks for hooks, home dotfiles, and ~/.config entries.
deploy_dotfiles() {
  info "Deploying dotfiles"
  [ -d "$DOTPATH" ] || {
    error "$DOTPATH not found"
    exit 1
  }
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
install_tools_via_brew() {
  command -v brew &>/dev/null || {
    error "Homebrew not found. Install it first."
    exit 1
  }

  brew update
  brew install curl git btop zsh tmux jq fzf ripgrep bat gcc unzip make pkg-config asdf git-secret
}

## @func install_devbox
#  Install devbox CLI for reproducible dev environments.
install_devbox() {
  info 'Installing devbox CLI'
  if command -v devbox &>/dev/null; then
    warn 'devbox already installed'
    return
  fi

  curl -fsSL https://get.jetify.com/devbox | bash -s -- -f
}

install_tools() {
  info "Installing devbox"
  install_devbox

  devbox global add ruby
  info "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  info "Installing tools via Homebrew"
  install_tools_via_brew
}

install_languages() {
  devbox global add deno go nodejs python3 rustup bun
}

## @func setup_rust
#  Set the Rust toolchain to stable and install useful Rust-based CLI tools.
setup_rust() {
  info "Configuring Rust"
  rustup default stable
  cargo install bob-nvim pueue
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
  install_languages
  setup_rust
  source "$HOME/dotfiles/shell/alias.sh"
  info "Installation complete!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_args "$@"
  main "$@"
fi
