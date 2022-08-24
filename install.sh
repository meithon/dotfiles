#!/usr/bin/env bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -euo pipefail

# set dotfiles path as default variable
if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=$HOME/dotfiles; export DOTPATH
fi

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
is_exists() {
  which "$1" >/dev/null 2>&1
  return $?
}



### Start install script
DOTFILES_GITHUB="https://github.com/MeiWagatsuma/dotfiles"; export DOTFILES_GITHUB

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

printf "%s" "$BOLD"
echo   "$dotfiles_logo"
printf "%s" "$NORMAL"

echo ""
read -p "$(warn 'Are you sure you want to install it? [y/N] ')" -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  error 'OK. Goodbye.'
  exit 1
fi

_download() {
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

_deploy() {
  info "Deploying dotfiles..."
  if [ ! -d "$DOTPATH" ]; then
    error "$DOTPATH: not found"
    exit 1
  fi

  mkdir -p ~/.config/nvim
  ln -si $DOTPATH/nvim/init.vim ~/.config/nvim/init.vim
  ln -si $DOTPATH/.zshrc ~/.zshrc
  ln -si $DOTPATH/.tmux.conf ~/.tmux.conf

  info "Deployed!"
}

# A script for the file named "setup"
dotfiles_setup() {
    # 1. Download the repository
    # ==> downloading
    # Priority: git > curl > wget
    _download &&

    # 2. Deploy dotfiles to your home directory
    # ==> deploying
    _deploy "$@"
}

dotfiles_setup "$@"
