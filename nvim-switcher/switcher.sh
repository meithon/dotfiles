#!/bin/bash
DIRECTORY_PATH="$HOME/dotfiles/nvim-switcher/lib"
CONFIG_PATH="$HOME/.config"


for dir in "$DIRECTORY_PATH"/*; do
    if [ -d "$dir" ]; then
        # シンボリックリンクを作成
        ln -s "$dir" "$CONFIG_PATH/$(basename "$dir")"
    fi
done

selected_dir=$(for dir in "$DIRECTORY_PATH"/*; do
    if [ -d "$dir" ]; then
        basename "$dir"
    fi
done | fzf)

echo $selected_dir

NVIM_APPNAME=$selected_dir nvim
