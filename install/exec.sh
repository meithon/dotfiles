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

main() {
  printf "%s" "$BOLD"
  echo "$dotfiles_logo"
  printf "%s" "$NORMAL"

  get_user_confirmation
  info "Downloading dotfiles..."
  # git_clone_dotfiles

  info "Deploying dotfiles..."
  ./deploy_dotfiles.sh
  # deploy_dotfiles
  info "Deployed!"

  info "Installing tools..."
  ./install_tools.sh
  . ~/dotfiles/shell/asdf.sh

  info "Setting up Asdf"
  ./setup_asdf.sh

  . ~/dotfiles/shell/envsetup.sh

  ./setup_rust.sh
  . ~/dotfiles/shell/alias.sh
}
main

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
