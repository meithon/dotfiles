if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "This is Linux "
  apt-get update
  apt-get install -y software-properties-common
  add-apt-repository ppa:apt-fast/stable
  apt-get update
  apt-get -y install apt-fast
  apt-fast install -y \
    curl \
    git \
    btop \
    zsh \
    tmux \
    jq \
    fzf \
    tmux \
    vim \
    gh \
    ripgrep \
    bat \
    gcc \
    unzip \
    make \
    pkg-config \
    libssl-dev

  apt-get clean
  rm -rf /var/lib/apt/lists/*
  if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  fi
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
