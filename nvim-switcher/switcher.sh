config=$(ls -d ~/dotfiles/nvim-switcher/lib/*/ | fzf)

NVIM_APPMNAME=$config nvim
