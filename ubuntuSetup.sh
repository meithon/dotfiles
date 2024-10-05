apt update
apt install -y curl git btop zsh tmux jq fzf tmux ripgrep bat gcc unzip make pkg-config libssl-dev

git clone https://github.com/MeiWagatsuma/dotfiles

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
. "$HOME/.asdf/asdf.sh"

export PATH=$(asdf where rust)/bin:$PATH
export JAVA_HOME=$(asdf where java)

rustup default stable
cargo install lsd sheldon bob-nvim pueue

# install neovim
bob use latest
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# ~/.proifile
echo 'export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"' >>~/.bashrc
echo '. "$HOME/.asdf/asdf.sh"' >>~/.bashrc
echo 'export PATH=$(asdf where rust)/bin:$PATH' >>~/.bashrc
echo 'export PATH=$(asdf where golang)/packages/bin:$PATH' >>~/.bashrc
echo 'alias vi="nvim"' >>~/.bashrc
echo 'alias ll="lsd -l"' >>~/.bashrc

source ~/.bashrc
