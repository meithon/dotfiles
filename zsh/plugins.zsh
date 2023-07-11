ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# vim mode
zinit ice depth"1"
zinit light jeffreytse/zsh-vi-mode

# 非同期処理できるようになる
zinit load mafredri/zsh-async

zinit ice depth"1"
zinit light romkatv/powerlevel10k

zinit load agkozak/zsh-z
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zinit load zsh-users/zsh-autosuggestions
# 補完強化
zinit load zsh-users/zsh-completions
# 256色表示にする
zinit load chrissicool/zsh-256color
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zinit load zsh-users/zsh-syntax-highlighting

zinit load BurntSushi/ripgrep

zinit load junegunn/fzf

zinit light Aloxaf/fzf-tab

zinit load zdharma-continuum/fast-syntax-highlighting

# For postponing loading `fzf`
zinit ice lucid wait
zinit snippet OMZP::fzf
