#!/usr/bin/env bash

DOTPATH=~/dotfiles
DOTFILES_YES_OPTION=false

parseArgs() {
  # オプションを処理
  while getopts "y" opt; do
    case $opt in
    y)
      DOTFILES_YES_OPTION=true
      echo "yyyyyyyyy"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    esac
  done

  shift $((OPTIND - 1))
}

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
  parseArgs
  printf "%s" "$BOLD"
  echo "$dotfiles_logo"
  printf "%s" "$NORMAL"

  get_user_confirmation
  git_clone_dotfiles

  envsetup
  setup_asdf
  deploy_dotfiles
  source ~/.envsetup.sh

  rustup default stable
  cargo install lsd sheldon bob-nvim pueue

  bob use latest
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
if [ -n "$tput" ]; then
  ncolors=$($tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BOLD=""
  NORMAL=""
fi

### functions
# info: output terminal green
info() {
  printf "%s" "$GREEN"
  echo -n "[+] "
  printf "%s" "$NORMAL"
  echo "$1"
}
# error: output terminal red
error() {
  printf "%s" "$RED"
  echo -n "[-] "
  printf "%s" "$NORMAL"
  echo "$1"
}
# warn: output terminal yellow
warn() {
  printf "%s" "$YELLOW"
  echo -n "[*] "
  printf "%s" "$NORMAL"
  echo "$1"
}
# log: out put termial normal
log() {
  echo "  $1"
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
  info "Downloading dotfiles..."

  if [ ! -d "$DOTPATH" ]; then
    if is_exists "git"; then
      git clone "$DOTFILES_GITHUB" "$DOTPATH"
      info "Downloaded"

    elif is_exists "curl" || is_exists "wget"; then
      local zip_url="https://github.com/MeiWagatsuma/dotfiles/archive/master.zip"

      if is_exists "curl"; then
        curl -L "$zip_url"

      elif is_exists "wget"; then
        wget -O - "$zip_url"
      fi | tar xvz

      if [ ! -d dotfiles-master ]; then
        error "dotfiles-master: not found"
        exit 1
      fi
      mv -f dotfiles-master "$DOTPATH"
      info "Downloaded!"

    else
      error "curl or wget required"
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
  info "Deploying dotfiles..."

  validate_dotpath_exists

  create_symlink "pre-commit" ".git/hooks/pre-commit"

  shopt -s dotglob
  for file in ~/dotfiles/home/*; do
    create_symlink "$file" ~/
  done

  mkdir -p ~/.config
  for file in ~/dotfiles/config/*; do
    create_symlink "$file" ~/.config/.
  done

  info "Deployed!"
}

envsetup() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "This is Linux "
    apt update
    apt install -y curl git btop zsh tmux jq fzf tmux ripgrep bat gcc unzip make pkg-config libssl-dev
    if [ ! -d "$HOME/.asdf" ]; then
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    fi

    . "$HOME/.asdf/asdf.sh"
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
  list=(
    deno
    golang
    nodejs
    python
    rust
    java
  )

  for i in "${list[@]}"; do
    (
      asdf plugin add $i
      asdf install $i latest
      asdf global $i latest
    ) &
    log "Installing asdf $i..."
  done
  wait
  info "Asdf setup done"
}

main
