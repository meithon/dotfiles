#!/usr/bin/env bash

DOTPATH=~/dotfiles
DOTFILES_YES_OPTION=false

# オプションを処理
while getopts "y" opt; do
  case $opt in
  y)
    DOTFILES_YES_OPTION=true
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

get_user_confirmation() {
  if [ "$DOTFILES_YES_OPTION" = true ]; then
    return
  fi

  echo ""
  read -p "$(warn 'Are you sure you want to install it? [y/N] ')" -n 1 -r
  echo ""

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    error 'OK. Goodbye.'
    exit 1
  fi
}
main() {
  printf "%s" "$BOLD"
  echo "$dotfiles_logo"
  printf "%s" "$NORMAL"

  get_user_confirmation
  info "Downloading dotfiles..."
  git_clone_dotfiles

  info "Deploying dotfiles..."
  deploy_dotfiles
  info "Deployed!"

  info "Installing tools..."
  install_tools
  . ~/dotfiles/shell/asdf.sh

  info "Setting up Asdf"
  setup_asdf

  . ~/dotfiles/shell/envsetup.sh

  rustup default stable
  cargo install lsd sheldon bob-nvim pueue

  bob use latest
  . ~/dotfiles/shell/alias.sh
}

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=$HOME/dotfiles
  export DOTPATH
fi

# set dotfiles path as default variable
set -euo pipefail

# load lib functions
# use colors on terminal
tput=$(which tput)
if [ -n "$tput" ] && [ -t 1 ]; then
  if ! ncolors=$($tput colors 2>/dev/null); then
    # tput execution failed, fallback to ANSI escape codes
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[0;33m"
    BOLD="\033[1m"
    NORMAL="\033[0m"
  elif [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$($tput setaf 1)"
    GREEN="$($tput setaf 2)"
    YELLOW="$($tput setaf 3)"
    BOLD="$($tput bold)"
    NORMAL="$($tput sgr0)"
  else
    # Terminal doesn't support enough colors
    RED=""
    GREEN=""
    YELLOW=""
    BOLD=""
    NORMAL=""
  fi
else
  # tput is not available, use ANSI escape codes
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BOLD="\033[1m"
  NORMAL="\033[0m"
fi

### functions
# info: output terminal green
info() {
  printf "${GREEN}[+] ${NORMAL}%s\n" "$1"
}
# error: output terminal red
error() {
  printf "${RED}[-] ${NORMAL}%s\n" "$1"
}
# warn: output terminal yellow
warn() {
  printf "${YELLOW}[*] ${NORMAL}%s\n" "$1"
}
# log: output terminal normal
log() {
  printf "  %s\n" "$1"
}

# check package & return flag
DOTFILES_GITHUB="https://github.com/MeiWagatsuma/dotfiles"

### Start install script
is_exists() {
  which "$1" >/dev/null 2>&1
  return $?
}
export DOTFILES_GITHUB

dotfiles_logo='
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝

*** WHAT IS INSIDE? ***
1. Download dotfiles from https://github.com/MeiWagatsuma/dotfiles
2. Install dev packages
   [coreutils bash vim git python tmux curl fish...]
3. Symbolik linking config files to your home directory

*** HOW TO INSTALL? ***
See the README for documentation.
Licensed under the MIT license.
'

git_clone_dotfiles() {

  if [ ! -d "$DOTPATH" ]; then
    if is_exists "git"; then
      git clone "$DOTFILES_GITHUB" "$DOTPATH"
      info "Downloaded"

    elif is_exists "curl" || is_exists "wget"; then
      local zip_url="https://github.com/MeiWagatsuma/dotfiles/archive/main.zip"
      local temp_file="/tmp/dotfiles.zip"

      if is_exists "curl"; then
        curl -L "$zip_url" -o "$temp_file"
      elif is_exists "wget"; then
        wget "$zip_url" -O "$temp_file"
      fi

      if [ ! -f "$temp_file" ]; then
        error "Failed to download dotfiles"
        exit 1
      fi

      if is_exists "unzip"; then
        unzip "$temp_file" -d "/tmp"
      elif is_exists "tar"; then
        # Some systems have tar with zip support
        tar -xvf "$temp_file" -C "/tmp"
      else
        error "unzip or tar command is required"
        rm "$temp_file"
        exit 1
      fi

      rm "$temp_file"

      if [ ! -d "/tmp/dotfiles-main" ]; then
        error "dotfiles-main: not found"
        exit 1
      fi
      mv -f "/tmp/dotfiles-main" "$DOTPATH"
      info "Downloaded!"

    else
      error "git, curl or wget required"
      exit 1
    fi

  else
    warn "Dotfiles are already installed"
  fi
}

validate_dotpath_exists() {
  if [ ! -d "$DOTPATH" ]; then
    error "$DOTPATH: not found"
    exit 1
  fi
}

check_file_exists() {
  if [ ! -e "$1" ]; then
    error "File $1 does not exist"
    exit 2
  fi
}

create_symlink() {
  local source=$1
  local target=$2

  if [ ! -e "$source" ]; then
    error "Source $source does not exist"
    return
  fi

  ln -sif "$source" "$target"
}

deploy_dotfiles() {

  validate_dotpath_exists

  create_symlink "pre-commit" ".git/hooks/pre-commit"

  shopt -s dotglob
  for file in ~/dotfiles/home/*; do
    create_symlink "$file" ~/
  done

  mkdir -p ~/.config
  for file in ~/dotfiles/config/*; do
    create_symlink "$file" ~/.config
  done

}

install_tools() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "This is Linux "
    apt-get update
    apt-get install -y software-properties-common
    add-apt-repository ppa:apt-fast/stable
    apt-get update
    apt-get -y install apt-fast
    apt-fast install -y \
      curl \
      git \
      btop \
      zsh \
      tmux \
      jq \
      fzf \
      tmux \
      vim \
      gh \
      ripgrep \
      bat \
      gcc \
      unzip \
      make \
      pkg-config \
      libssl-dev
    if [ ! -d "$HOME/.asdf" ]; then
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "This is macOS."
    # TODO: Check if homebrew is installed
    export PATH=/opt/homebrew/bin:$PATH
    brew install curl git btop zsh tmux jq fzf tmux ripgrep bat gcc unzip make pkg-config
    brew install asdf
  else
    echo "This is an unsupported OS."
    exit 1
  fi

}

setup_asdf() {
  local list=(
    "deno"
    "golang"
    "nodejs"
    "python"
    "rust"
  )

  # Check if asdf is installed
  if ! command -v asdf &>/dev/null; then
    echo "Error: asdf is not installed. Please install it first."
    return 1
  fi

  for lang in "${list[@]}"; do
    (
      asdf plugin add "$lang"
      asdf install "$lang" latest
      asdf global "$lang" latest
      info "Installed asdf $lang"
    )
  done

  (
    asdf plugin add java
    asdf install java openjdk-21.0.2
    asdf global java openjdk-21.0.2
  )
  wait
}

main
