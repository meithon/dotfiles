# # Enable Powerlevel10k instant prompt. Should stay close to the top of ./.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
#
#
# typeset -A ZI
# ZI[BIN_DIR]="${HOME}/.zi/bin"
# source "${ZI[BIN_DIR]}/zi.zsh"
# autoload -Uz _zi
# (( ${+_comps} )) && _comps[zi]=_zi


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"



# 補完システムの初期化
autoload -Uz compinit
compinit -u

# 補完のキャッシュ設定
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompcache

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
#
# # zi ice svn
# # zi snippet OMZP::history-substring-search
#
# zi ice blockf
zi light zsh-users/zsh-completions


# zi ice svn silent wait'!1' atload'prompt smiley'
# zi snippet PZT::modules/prompt

zi ice depth"1" 
zi light romkatv/powerlevel10k  
# Enable Powerlevel10k instant prompt. Should stay close to the top of ./.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh 




zi ice wait lucid atload'!_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

zinit wait"1" lucid as"program" for \
    cp"wd.sh -> wd" mv"_wd.sh -> _wd" \
    atpull"!git reset --hard" pick"wd" \
  mfaerevaag/wd \
    id-as"git-unique" pick"git-unique" \
  https://github.com/Osse/git-scripts/blob/master/git-unique \
    pick"bin/git-dsf" \
  z-shell/zsh-diff-so-fancy \
    has"bat" pick"src/*" \
  eth-p/bat-extras \
    has"git" atclone"cp git-open.1.md $ZI[MAN_DIR]/man1/git-open.1" \
    atpull"%atclone" \
  paulirish/git-open \
    atclone"cp hr.1 $ZI[MAN_DIR]/man1" atpull"%atclone" \
  LuRsT/hr \
    has"gpg" \
  dylanaraps/pash \
    make"!" atclone"./direnv hook zsh > zhook.zsh" \
    atpull"%atclone" src"zhook.zsh" \
  direnv/direnv 

zi ice wait"1" lucid
zi light sunlei/zsh-ssh



zinit lucid for \
    atinit'
      function zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
        # FIXME: なぜか効かない
        ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
        ZVM_VI_ESCAPE_BINDKEY=jk
      }
    ' \
    atload'source ~/dotfiles/zi/plugin/zsh-vi-mode.zsh' \
  jeffreytse/zsh-vi-mode \
  zdharma-continuum/fast-syntax-highlighting \
  dim-an/cod \
    atload" \
      # export PER_DIRECTORY_HISTORY_TOGGLE=^V
      # add-zsh-hook precmd __bind_per_directory_history_toggle_history
      #
      # function __bind_per_directory_history_toggle_history() {
      #   bindkey -M vicmd '^v' per-directory-history-toggle-history
      # } 
      " \
  jimhester/per-directory-history \
  Aloxaf/fzf-tab \
    as"program" \
    from"gh-r" \
    pick"zoxide" \
    atclone"./zoxide init zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" \
    atload'source ~/dotfiles/zi/plugin/zoxide.zsh' \
  ajeetdsouza/zoxide

# nulls
zinit wait lucid for \
    has'asdf' atload'source ~/dotfiles/shell/envsetup.sh' \
  zdharma-continuum/null \
    has"thefuck" atload'eval $(thefuck --alias fk)' \
  zdharma-continuum/null \
    has"bun" atload'
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"' \
  zdharma-continuum/null


zi ice wait lucid \
  atload'source ~/dotfiles/zi/plugin/zsh-abbrev-alias.zsh'
# zi light momo-lab/zsh-abbrev-alias
# FIXME: per-directory-historyと干渉している
# 以下のコマンドでhookを削除すると使えるようになる
# add-zsh-hook -d zshaddhistory _per-directory-history-addhistory
# zinit light akash329d/zsh-alias-finder
# zinit ice src="alias-finder.plugin.zsh"
# zinit snippet OMZ::plugins/alias-finder/alias-finder.plugin.zsh
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# zinit light akash329d/zsh-alias-finder
# zi ice wait lucid \
#   pick'auto-fu.zsh'
# zinit light hchbaw/auto-fu.zsh 

zinit ice wait lucid src'autopair.zsh'
zinit light hlissner/zsh-autopair  # add autopair quote, brackets
zinit ice wait lucid src"bd.zsh" atload"zicompinit; zicdreplay"
zinit light Tarrasch/zsh-bd #Quickly go back to a specific parent directory instead of typing cd ../../.. redundantly.

# Lazy git commit tools
# escape single quote of command argument
# it just: git pull -rebase && git add . && git commit '${message}'
zinit wait lucid for \
    atload'
      ZAQ_PREFIXES+=("c")
    ' \
  ianthehenry/zsh-autoquoter \
  sebastiangraz/c

zinit light wintermi/zsh-brew # setup homebrew completion

# fpath=(/path/to/dir/cd-reporoot(N-/) $fpath)
#
# autoload -Uz cd-reporoot
# zinit wait lucid for \
#       atload"
#         autoload -Uz cd-reporoot
#         alias cdr='cd-reporoot'
#       " \
#       has"git" \
#     P4Cu/cd-reporoot \
#     MikeDacre/cdbk # can create alias directory
zinit light willghatch/zsh-cdr
zinit light 0b10/cheatsheet
zinit light zpm-zsh/clipboard

zinit light BlaineEXE/zsh-cmd-status 
ZSH_CMD_STATUS_DURATION_THRESHOLD=5 # default 10


# zinit light tom-doerr/zsh_codex
#   bindkey -M viins '^X' create_completion
#   bindkey -M vicmd '^X' create_completion

zinit light zuxfoucault/colored-man-pages_mod
zinit light Freed-Wu/zsh-colorize-functions

# zinit ice depth'1' src'ble.sh' nocompile \
#     atclone"make PREFIX=~/.local" \
#     atpull'%atclone' \
#     compile'src/*/*.C'
# zinit light akinomyoga/ble.sh

zinit light D3STY/cros-auto-notify-zsh # Automatically sends out a notification when a long running task

zinit ice lucid src'deer'
zinit light Vifon/deer # cloudnt load with wait

autoload -U deer
zle -N deer
bindkey -M viins '^K' deer
bindkey -M vicmd '^K' deer

# zinit ice lucid src'zsh-delete-prompt.zsh'
# zinit light aoyama-val/zsh-delete-prompt

# ignore $
zinit light zpm-zsh/undollar


zinit ice lucid \
    atclone"${0:A:h}/install.sh" \
    atpull'%atclone'
zinit light kuoe0/zsh-depot-tools

# zinit light AdrieanKhisbe/diractions
# zinit light webyneter/docker-aliases
# zplug "kuoe0/zsh-depot-tools", hook-build:"./install.sh"

# expect next command
zinit ice lucid src="init.zsh"
zinit light oknowton/zsh-dwim

# zinit ice atclone"make build" atpull"%atclone"
# zinit light decayofmind/zsh-fast-alias-tips

zinit light djui/alias-tips
zinit light QuarticCat/zsh-smartcache
  export ZSH_PLUGINS_ALIAS_TIPS_TEXT="💡 Alias tip: "

# zinit load wfxr/forgit
# zinit ice src"zsk-git-worktrees.zsh"
# zinit light egyptianbman/zsh-git-worktrees

zinit ice multisrc="_hist"
zinit light marlonrichert/zsh-hist

zinit load zdharma-continuum/history-search-multi-word

# down-line-or-execute() {
#     if [[ -n $BUFFER ]]; then
#         # バッファが空でない場合、通常の下方向移動
#         zle down-line-or-history
#         # 次の履歴項目が存在しない場合（最後に到達）、実行
#         # if [[ ${#history[$((HISTCMD+1))]} -eq 0 ]]; then
#         #     zle accept-line
#         # fi
#         KEYS=$'\033[B'  # 下キーのキーコードを直接設定
#         print -n '\e[B'  # 下キーの制御シーケンスを送信
#         printf '\016' > /dev/tty  # Ctrl-N（下方向）を送信
#     else
#         zle history-search-multi-word
#     fi
# }
#
# # 新しい Widget として登録
# zle -N down-line-or-execute
#
# # 下矢印キーにバインド
# bindkey -M viins '^[[B' down-line-or-execute
# bindkey -M vicmd '^[[B' down-line-or-execute

zinit light yzdann/kctl
zinit load Dbz/kube-aliases

# zinit light romkatv/zsh-no-ps2
# zinit light deyvisonrocha/pantheon-terminal-notify-zsh-plugin # for x server
zinit light t413/zsh-background-notify

zinit light "wintermi/zsh-rust"

zinit ice src"shell-plugins/shellfirm.plugin.zsh"
zinit light kaplanelad/shellfirm

zinit ice wait lucid
zinit load redxtech/zsh-show-path

# TODO: 多分zsh-syntax-highlightingのディレクトリに移動させないと行けない
zinit ice src"zsh-syntax-highlighting-filetypes.zsh" 
zinit light trapd00r/zsh-syntax-highlighting-filetypes
# zinit ice src"lscolor.sh"
# zinit light trapd00r/LS_COLORS 

# TODO: cache output of vivid
export LS_COLORS="$(vivid generate tokyonight-storm)"
zinit light paulmelnikow/zsh-startup-timer

# zinit ice atload'zsh-startify' 
# zinit load NorthIsMirror/zsh-startify
# zstyle ":plugin:zsh-startify:shellutils" size 5  # The size of the recently used file list (default: 5)
# zstyle ":plugin:zsh-startify:vim" size 5         # The size of the recently opened in Vim list (default: 5)

zinit light mollifier/zload
zinit ice src"tipz.zsh"
zinit light molovo/tipz

# FIXME: 動かない
# export YSU_HARDCORE=1
# export YSU_IGNORED_ALIASES=("$")
# zinit light "MichaelAquilina/zsh-you-should-use"

zinit ice \
    src"url/url-highlighter.zsh" \
    atclone"mkdir -p \${ZINIT[PLUGINS_DIR]}/zsh-syntax-highlighting/highlighters && \
            ln -sf \$PWD/url \${ZINIT[PLUGINS_DIR]}/zsh-syntax-highlighting/highlighters/url" \
    atpull'%atclone'
zinit light ascii-soup/zsh-url-highlighter

# undo in git
zinit light Bhupesh-V/ugit
zinit ice src"vimman.zsh"
zinit light yonchu/vimman
export LSCOLORS=$LS_COLORS
zinit ice atload'export PATH="$PATH:${ZINIT[PLUGINS_DIR]}/unixorn---warhol.plugin.zsh/bin"'
# colorize output of command with grc
zinit light unixorn/warhol.plugin.zsh

zinit light https://github.com/Anant-mishra1729/web-search/
export ZSH_WEB_SEARCH_ENGINES=(
    reddit "https://www.reddit.com/search?q="
    )
# zinit ice as"program"  \
#   atclone"./install.sh" \
#   atpull'%atclone'
# zinit light garabik/grc


# can define alias as yaml
# zinit blockf light-mode as"program" from"gh-r" for \
#     atload'eval "$(zabrze init --bind-keys)"' \
#     Ryooooooga/zabrze
# ~/.config/zabrze/config.yaml
  


function fzf-history-search() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ") CURSOR=$#BUFFER
}


  # echo "ZLE initialized - zle commands available"
  # bindkey -M viins '^v' per-directory-history-toggle-history
  # bindkey -M vicmd '^v' per-directory-history-toggle-history
  #
  #
  #
  # zle -N fzf-history-search
  # bindkey -M viins '^r' fzf-history-search
  # bindkey -M vicmd '^r' fzf-history-search
source ~/dotfiles/zi/plugin/fzf.zsh
source ~/dotfiles/zi/plugin/zoxide.zsh

