function deploy_dotfiles() {
  create_symlink "pre-commit" ".git/hooks/pre-commit"

  # shopt -s dotglob
  for file in ~/dotfiles/home/*; do
    create_symlink "$file" ~/
  done

  mkdir -p ~/.config
  for file in ~/dotfiles/config/*; do
    create_symlink "$file" ~/.config
  done
}
deploy_dotfiles
create_symlink() {
  local source=$1
  local target=$2

  if [ ! -e "$source" ]; then
    error "Source $source does not exist"
    return
  fi

  ln -sif "$source" "$target"
}
