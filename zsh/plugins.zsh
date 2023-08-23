ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# for lazy load
zinit light romkatv/zsh-defer
# 非同期処理できるようになる
zinit load mafredri/zsh-async

# vim mode
zinit ice depth"1"
zinit light jeffreytse/zsh-vi-mode

zinit ice depth"1"
zinit light romkatv/powerlevel10k

zsh-defer zinit load agkozak/zsh-z
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zsh-defer zinit load zsh-users/zsh-autosuggestions
# 補完強化
zsh-defer zinit wait'0' lucid light-mode for zsh-users/zsh-completions
# 256色表示にする
zsh-defer zinit load chrissicool/zsh-256color
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zsh-defer zinit load zsh-users/zsh-syntax-highlighting

zsh-defer zinit load BurntSushi/ripgrep

zsh-defer zinit load junegunn/fzf
zsh-defer zinit wait'0' lucid light-mode for Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 2 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

zsh-defer zinit wait'0' lucid light-mode for zdharma-continuum/fast-syntax-highlighting

# For postponing loading `fzf`
zsh-defer zinit ice lucid wait
zsh-defer zinit snippet OMZP::fzf


## golang
zinit wait lucid for \
 dim-an/cod
