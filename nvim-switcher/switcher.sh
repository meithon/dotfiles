DIRECTORY_PATH="$HOME/dotfiles/nvim-switcher/lib"

selected_dir=$(for dir in "$DIRECTORY_PATH"/*; do
    if [ -d "$dir" ]; then
        basename "$dir"
    fi
done | fzf)

echo $selected_dir

NVIM_APPNAME=$selected_dir nvim
