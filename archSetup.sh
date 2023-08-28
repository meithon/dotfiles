#!/bin/bash
INSTLOG="install.log"

#-- パッケージ -----------------------------------------
dm_packages=(
    sddm # モダンなディスプレイマネージャ
    sddm-theme-corners-git
    # │
    # ├─ sddm
    # ├─ qt5-graphicaleffects
    # ├─ qt5-svg
    # ├─ qt5-quickcontrols2
    # └─ git              # バージョン管理システム
)

input_tools=(
    fcitx5-im # 入力メソッドフレームワーク
    # │
    # ├─ fcitx5
    # ├─ fcitx5-configtool
    # ├─ fcitx5-gtk
    # └─ fcitx5-qt
    fcitx5-mozc # Mozcに基づく日本語入力メソッド
)

themes=(
    dracula-icons-git
    dracula-gtk-theme
)

font_resources=(
    otf-font-awesome # アイコンフォント
    ttf-symbola      # Unicodeの記号と文字のフォント
    ttf-twemoji      # TwitterのEmoji用フォント
    noto-fonts-cjk   # GoogleのNoto CJKフォント
    ttf-nerd-fonts-symbols
    ttf-jetbrains-mono-nerd
    ttf-hack-nerd
    ttf-firacode-nerd # モノスペースのコーディング用フォント
)

wayland_apps=(
    wl-clipboard                # Waylandのクリップボードユーティリティ
    grim                        # Waylandのスクリーンショットユーティリティ
    slurp                       # Waylandの領域選択ユーティリティ
    wofi                        # Waylandのランチャー
    wlogout                     # Waylandのログアウトユーティリティ
    xdg-desktop-portal-hyprland # 不明
    mako                        # Wayland通知デーモン
    waybar                      # Wayland用のステータスバー
    swaybg                      # 壁紙
    swaylock-effects            # swayのロックスクリーン
)

packages=(
    "${dm_packages[@]}"
    "${input_tools[@]}"
    "${themes[@]}"
    "${font_resources[@]}"
    "${core_apps[@]}"
    "${wayland_apps[@]}"
)

# install yay
if [ ! -f /sbin/yay ]; then
    echo -en "Configuering yay."
    git clone https://aur.archlinux.org/yay.git &>>$INSTLOG
    cd yay
    makepkg -si --noconfirm &>>../$INSTLOG
    cd ..
    rm -rf yay
fi


install_software() {
    echo -en "\e[90mInstalling\e[0m \e[97m$1\e[0m..."
    yay -S --noconfirm $1 &>>$INSTLOG &
		show_progress $!
}
# Display the header
display_header() {
    echo -e "\e[K:: Installing package ($current_package/$package_count)"
}
# Print the last DISPLAY_LINES actions
display_actions() {
    local start_index=$((current_package - DISPLAY_LINES))
    if [ $start_index -lt 0 ]; then
        start_index=0
    fi
    for ((i = 0; i < DISPLAY_LINES; i++)); do
        echo -en "\e[K"
        if [ $((start_index + i)) -lt $current_package ]; then
            echo "  Installing ${packages[start_index + i]}.."
        else
            echo ""
        fi
    done
}

# Manage the entire display
display_installation() {
    echo -en "\e[${CURSOR_MOVE}A"
    display_header
    display_actions
}

for SOFTWR in ${packages[@]}; do
    install_software $SOFTWR &>/dev/null
    ((current_package++))
    display_installation
done
