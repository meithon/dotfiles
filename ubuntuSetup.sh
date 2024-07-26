apt install -y neovim curl git btop zsh tmux jq fzf tmux ripgrep bat gcc unzip make pkg-config libssl-dev

git clone https://github.com/MeiWagatsuma/dotfiles

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

list=(
  deno
  golang
  nodejs
  python
  rust
)

for i in "${list[@]}"; do
  asdf plugin add $i
  asdf install $i latest
  asdf global $i latest
done

cargo install lsd sheldon
cargo install bob-nvim

echo 'export PATH=$(asdf where rust)/bin:$PATH' >>~/.zshrc
export PATH=$(asdf where rust)/bin:$PATH
. "$HOME/.asdf/asdf.sh"

alias vi=/root/.local/share/bob/nvim-bin/nvim

