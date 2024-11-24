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


typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
zinit light paulmelnikow/zsh-startup-timer

# 補完システムの初期化
autoload -Uz compinit
compinit -u

# # 補完のキャッシュ設定
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path ~/.zcompcache

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# zi ice svn
# zi snippet OMZP::history-substring-search

# zi ice blockf
zinit ice lucid wait 
zinit light zsh-users/zsh-completions


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




zinit ice wait lucid atload'!_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

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

zinit ice wait"1" lucid
zinit light sunlei/zsh-ssh



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

ZSH_CMD_STATUS_DURATION_THRESHOLD=5 # default 10
# Lazy git commit tools
# escape single quote of command argument
# it just: git pull -rebase && git add . && git commit '${message}'
zinit wait lucid for \
    atload'
      ZAQ_PREFIXES+=("c")
    ' \
  ianthehenry/zsh-autoquoter \
  sebastiangraz/c \
  wintermi/zsh-brew \
  willghatch/zsh-cdr \
  0b10/cheatsheet \
  zpm-zsh/clipboard \
  BlaineEXE/zsh-cmd-status  \
  zuxfoucault/colored-man-pages_mod \
  Freed-Wu/zsh-colorize-functions \
  D3STY/cros-auto-notify-zsh # Automatically sends out a notification when a long running task 


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

# zinit light tom-doerr/zsh_codex
#   bindkey -M viins '^X' create_completion
#   bindkey -M vicmd '^X' create_completion


# zinit ice depth'1' src'ble.sh' nocompile \
#     atclone"make PREFIX=~/.local" \
#     atpull'%atclone' \
#     compile'src/*/*.C'
# zinit light akinomyoga/ble.sh


# zinit ice lucid src'deer'
# zinit light Vifon/deer # cloudnt load with wait
# autoload -U deer
# zle -N deer
# bindkey -M viins '^K' deer
# bindkey -M vicmd '^K' deer

# zinit ice lucid src'zsh-delete-prompt.zsh'
# zinit light aoyama-val/zsh-delete-prompt

# ignore $

# zinit light AdrieanKhisbe/diractions
# zinit light webyneter/docker-aliases
# zplug "kuoe0/zsh-depot-tools", hook-build:"./install.sh"

# zinit ice atclone"make build" atpull"%atclone"
# zinit light decayofmind/zsh-fast-alias-tips
# zinit load wfxr/forgit
# zinit ice src"zsk-git-worktrees.zsh"
# zinit light egyptianbman/zsh-git-worktrees

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

# zinit light romkatv/zsh-no-ps2
# zinit light deyvisonrocha/pantheon-terminal-notify-zsh-plugin # for x server


# TODO: 多分zsh-syntax-highlightingのディレクトリに移動させないと行けない

# zinit ice src"lscolor.sh"
# zinit light trapd00r/LS_COLORS 


# zinit ice atload'zsh-startify' 
# zinit load NorthIsMirror/zsh-startify
# zstyle ":plugin:zsh-startify:shellutils" size 5  # The size of the recently used file list (default: 5)
# zstyle ":plugin:zsh-startify:vim" size 5         # The size of the recently opened in Vim list (default: 5)

# zdharma-continuum/history-search-multi-word \

# TODO: cache output of vivid
export LS_COLORS="$(vivid generate tokyonight-storm)"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="💡 Alias tip: "
  # djui/alias-tips \
zinit wait lucid for \
  zpm-zsh/undollar \
    atclone"${0:A:h}/install.sh" \
    atpull'%atclone' \
  kuoe0/zsh-depot-tools \
    src="init.zsh" \
  oknowton/zsh-dwim \
  QuarticCat/zsh-smartcache \
  marlonrichert/zsh-hist \
  yzdann/kctl \
  Dbz/kube-aliases \
  t413/zsh-background-notify \
  wintermi/zsh-rust \
  redxtech/zsh-show-path \
    src"zsh-syntax-highlighting-filetypes.zsh"  \
  trapd00r/zsh-syntax-highlighting-filetypes \
  mollifier/zload 
  #   src"tipz.zsh" \
  # molovo/tipz 
  #   src"shell-plugins/shellfirm.plugin.zsh" \
  # kaplanelad/shellfirm \

# FIXME: 動かない
# export YSU_HARDCORE=1
# export YSU_IGNORED_ALIASES=("$")
# zinit light "MichaelAquilina/zsh-you-should-use"
  #   src"url/url-highlighter.zsh" \
  #   atclone"
  #     mkdir -p \${ZINIT[PLUGINS_DIR]}/zsh-syntax-highlighting/highlighters && \
  #     ln -sf \$PWD/url \${ZINIT[PLUGINS_DIR]}/zsh-syntax-highlighting/highlighters/url" \
  #   atpull'%atclone' \
  # ascii-soup/zsh-url-highlighter \

export LSCOLORS=$LS_COLORS
export ZSH_WEB_SEARCH_ENGINES=(
  reddit "https://www.reddit.com/search?q="
)

zinit wait lucid for \
  Bhupesh-V/ugit \
     src"vimman.zsh" \
  yonchu/vimman \
    atload'export PATH="$PATH:${ZINIT[PLUGINS_DIR]}/unixorn---warhol.plugin.zsh/bin"' \
  unixorn/warhol.plugin.zsh \
  Anant-mishra1729/web-search
# zinit ice as"program"  \
#   atclone"./install.sh" \
#   atpull'%atclone'
# zinit light garabik/grc


# can define alias as yaml
# zinit blockf light-mode as"program" from"gh-r" for \
#     atload'eval "$(zabrze init --bind-keys)"' \
#     Ryooooooga/zabrze
# ~/.config/zabrze/config.yaml
  


# function fzf-history-search() {
#   BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ") CURSOR=$#BUFFER
# }


source ~/dotfiles/zi/plugin/zoxide.zsh



find-repository-and-move() {
  local repo=$(ghq list | fzf)
  cd ~/ghq/$repo
  echo moved to \"$repo\"
}

alias repos=find-repository-and-move
alias -g rps='repos'

zinit lucid for larkery/zsh-histdb

_zsh_autosuggest_strategy_histdb_top() {
    local query="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape $1)%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape $PWD)', count(*) desc
        limit 1
    "
    suggestion=$(_histdb_query "$query")
}


find_most_used_command() {
  local query="
    select commands.argv from history
    left join commands on history.command_id = commands.rowid
    left join places on history.place_id = places.rowid
    where commands.argv LIKE '$(sql_escape $1)%'
    group by commands.argv, places.dir
    order by places.dir != '$(sql_escape $PWD)'
  "
  suggestion=$(_histdb_query "$query")
  echo $suggestion
}

find_command_in_current_dir() {
  local query="
    select commands.argv from history
    left join commands on history.command_id = commands.rowid
    left join places on history.place_id = places.rowid
    where commands.argv LIKE '$(sql_escape $1)%'
    and places.dir = '$(sql_escape $PWD)'
    group by commands.argv
    order by count(*) desc
  "
  suggestion=$(_histdb_query "$query")
  echo $suggestion
}

_per_directory_history_is_global=0

per-directory-history-toggle-history() {
    # グローバル変数の初期化
    if [[ -z "$_per_directory_history_is_global" ]]; then
        _per_directory_history_is_global=0
    fi

    # 現在のディレクトリのヒストリーファイル
    local directory_history_file="${HOME}/.zsh_history_${PWD//\//_}"

    if [[ $_per_directory_history_is_global -eq 0 ]]; then
        # ローカル→グローバル切り替え
        _per_directory_history_is_global=1
        local msg="📝 History Mode: Global"
    else
        # Switch from global to directory-specific history
        _per_directory_history_is_global=0
        local msg="📂 History Mode: Directory-specific"
    fi

    print "$msg"
    print
    zle reset-prompt
}

zle -N per-directory-history-toggle-history
bindkey -M vicmd '^v' per-directory-history-toggle-history
bindkey -M viins '^v' per-directory-history-toggle-history

ZSH_AUTOSUGGEST_STRATEGY=histdb_top

zinit snippet OMZ::plugins/git/git.plugin.zsh



zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zinit load 'Freed-Wu/fzf-tab-source'

zinit ice wait src'ls-colors.zsh'
zinit load 'xPMo/zsh-ls-colors'

__skimcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${SKIM_TMUX:-0}" != 0 ] || [ -n "$SKIM_TMUX_OPTS" ]; } &&
    echo "sk-tmux ${SKIM_TMUX_OPTS:--d${SKIM_TMUX_HEIGHT:-40%}} -- " || echo "sk"
}

function search_history() {
  local sql_query
  if [[ -z "$_per_directory_history_is_global" ]] || [[ $_per_directory_history_is_global -eq 1 ]]; then
    sql_query="
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      where commands.argv != ''
      group by commands.argv
      order by max(history.start_time) desc, count(*) desc
    "
  else
    # グローバル履歴から検索
    sql_query="
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where places.dir = '$(sql_escape $PWD)'
        and commands.argv != ''
      group by commands.argv
      order by max(history.start_time) desc, count(*) desc
    "
  fi

  local fzf_preview_cmd='echo {}| syncat -l bash'
  
  # 配列を使用する方法
  local -a fzf_opts=(
      --read0
      --ansi
      --layout=reverse
      --no-sort
      --height=60%
      --highlight-line
      --preview='echo {}| syncat -l bash'
      --preview-window=right:50%:wrap
      --prompt='History > '
      --header='[CTRL-Y:copy, CTRL-R:execute, ESC:exit]'
      --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)+abort'
      --bind 'ctrl-r:execute(echo {} | sh)+abort'
      --bind 'ctrl-v:execute(per-directory-history-toggle-history)'
      --bind 'esc:abort'
      --bind 'ctrl-/:toggle-preview'
      --color='header:italic:underline'
  )


  local history_data="$(
    _histdb_query -json "$sql_query"
  )"
  local processed_data
  processed_data=$(
    jq -j '.[].argv | gsub("\n$";"") + "\u0000"' <<<"$history_data" | \
    perl -pe 's/\x00/;\n\x1E/g' |  \
    perl -pe 's/\x1E$//' | \
    syncat --language bash | \
    perl -0777 -pe 's/;\n+/\x00/g'
  )

  local selected_command="$(echo "$processed_data" | fzf "${fzf_opts[@]}")"

  BUFFER=$(echo $selected_command)
  CURSOR=$#BUFFER
}

zle -N search_history
bindkey '^r' search_history
bindkey -M vicmd '^r' search_history
bindkey -M viins '^r' search_history
unsetopt HIST_REDUCE_BLANKS      # 空白の削除を無効化（改行を保持したい場合）

# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#   --color=fg:-1,fg+:#c9fdff,bg:-1,bg+:#060715
#   --color=hl:#ff29c2,hl+:#ff5ea9,info:#afaf87,marker:#87ff00
#   --color=prompt:#d7005f,spinner:#af5fff,pointer:#ff0062,header:#87afaf
#   --color=gutter:#181515,border:#a28580,separator:#51384c,scrollbar:#666363
#   --color=label:#aeaeae,query:#d9d9d9
#   --border="thinblock" --border-label="" --preview-window="border-thinblock" --padding="0,1"
#   --layout="reverse" --info="right"'


zinit light qoomon/zsh-lazyload
lazyload kubecolor -- 'source <(kubectl completion zsh);compdef kubecolor="kubectl"'
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
