# dotfiles

This is my config file

## 📦 Installation

### Automatic

Copy and execute this.

```bash
bash -c "`curl -fsSL https://raw.githubusercontent.com/MeiWagatsuma/dotfiles/master/install.sh`"
```

### Manualy

Clone this repository to home directory, and run `install.sh`.

## ⚡️ Requirements

### Terminal

- a [Nerd Font](https://www.nerdfonts.com/) (optional)
- Tmux (optional)
- FZF (optional)

### Neovim

- Neovim >= **0.8.1** (needs to be built with **LuaJIT**)
- [ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter) (optional for [image.nvim](https://github.com/samodostal/image.nvim))
- Node.js (required for LSP)
- luarocks (required for linter of lua)
- jq, tidy (optional formatter for [rest.nvim](https://github.com/rest-nvim/rest.nvim))
- [zoxide](https://github.com/ajeetdsouza/zoxide) (optional for telescope-zoxide)

## Secrets Management

This repository uses [git-secret](https://git-secret.io/) to manage encrypted secrets.

Prerequisites:
- Install git-secret:
  - macOS: brew install git-secret
  - Linux: sudo apt install git-secret

Usage:
# Initialize secret management
./manage-secrets.sh init <your-gpg-key>
# Add files to be managed (create secrets/ directory if needed)
./manage-secrets.sh add secrets/mysecret.env
# Encrypt secrets and commit
./manage-secrets.sh hide
# Decrypt secrets (only locally)
./manage-secrets.sh reveal

Encrypted files have the .secret extension and are tracked by Git.
Plaintext secret files are ignored per .gitignore.
