if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh


# 非同期処理できるようになる
zpm load @github/mafredri/zsh-async

zpm load @github/romkatv/powerlevel10k

zpm load @github/agkozak/zsh-z
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zpm load @github/zsh-users/zsh-autosuggestions
# 補完強化
zpm load @github/zsh-users/zsh-completions
# 256色表示にする
zpm load @github/chrissicool/zsh-256color
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zpm load @github/zsh-users/zsh-syntax-highlighting

zpm load @github/BurntSushi/ripgrep

zpm load @github/junegunn/fzf

zpm load @github/Aloxaf/fzf-tab

zpm load @github/zdharma-continuum/fast-syntax-highlighting



# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load
