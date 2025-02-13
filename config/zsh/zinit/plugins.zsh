ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# 補完システムの初期化
autoload -Uz compinit
compinit -u
# # 補完のキャッシュ設定
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompcache
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit



zi ice depth"1" 
zi light romkatv/powerlevel10k  
# Enable Powerlevel10k instant prompt. Should stay close to the top of ./.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh 


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
    atload'source ~/dotfiles/config/zsh/plugin/zsh-vi-mode.zsh' \
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
  `# FIXME: atload'zstyle ":completion:*" list-colors \${(s.:.)LS_COLORS}'` \
  Freed-Wu/fzf-tab-source \
    as"program" \
    from"gh-r" \
    pick"zoxide" \
    atclone"./zoxide init zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" \
    atload'source ~/dotfiles/config/zsh/plugin/zoxide.zsh' \
  ajeetdsouza/zoxide \
    atload'source ~/dotfiles/config/zsh/plugin/histdb.zsh' \
  larkery/zsh-histdb \
    atload'typeset -g POWERLEVEL9K_INSTANT_PROMPT=off' \
  paulmelnikow/zsh-startup-timer \
  romkatv/zsh-defer \
  ;




ZSH_CMD_STATUS_DURATION_THRESHOLD=5 # default 10
# TODO: cache output of vivid
export LS_COLORS="$(vivid generate tokyonight-storm)"


zinit wait lucid for \
    atload'
      ZAQ_PREFIXES+=("c")
    ' \
  ianthehenry/zsh-autoquoter `# escape single quote of command argument` \
  sebastiangraz/c `# it just: git pull -rebase && git add . && git commit '${message}'` \
  wintermi/zsh-brew \
  willghatch/zsh-cdr \
  0b10/cheatsheet \
  zpm-zsh/clipboard \
  BlaineEXE/zsh-cmd-status  \
  zuxfoucault/colored-man-pages_mod \
  Freed-Wu/zsh-colorize-functions \
  D3STY/cros-auto-notify-zsh `# Automatically sends out a notification when a long running task` \
    src'autopair.zsh' \
  hlissner/zsh-autopair  `# add autopair quote, brackets` \
    src"bd.zsh" atload"zicompinit; zicdreplay" \
  Tarrasch/zsh-bd `# Quickly go back to a specific parent directory instead of typing cd ../../.. redundantly.` \
    atload'source ~/dotfiles/config/zsh/plugin/zsh-abbrev-alias.zsh' \
  momo-lab/zsh-abbrev-alias \
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
  mollifier/zload \
  Bhupesh-V/ugit \
     src"vimman.zsh" \
  yonchu/vimman \
    atload'export PATH="$PATH:${ZINIT[PLUGINS_DIR]}/unixorn---warhol.plugin.zsh/bin"' \
  unixorn/warhol.plugin.zsh \
    atload'
      export LSCOLORS=$LS_COLORS
      export ZSH_WEB_SEARCH_ENGINES=(
        reddit "https://www.reddit.com/search?q="
      )
    ' \
  Anant-mishra1729/web-search `# this is a comment` \
  `#src"tipz.zsh"` \
  `# molovo/tipz` \
  `#   src"shell-plugins/shellfirm.plugin.zsh"` \
  `# kaplanelad/shellfirm` \
  `# TODO: 多分zsh-syntax-highlightingのディレクトリに移動させないと行けない` \
  `#   src"lscolor.sh"` \
  `# trapd00r/LS_COLORS` \
  `# zdharma-continuum/history-search-multi-word` \
  `# export ZSH_PLUGINS_ALIAS_TIPS_TEXT="💡 Alias tip: " ` \
  `# djui/alias-tips` \
  zsh-users/zsh-completions \
    atload'!_zsh_autosuggest_start' \
  zsh-users/zsh-autosuggestions \
  tom-doerr/zsh_codex \
  ;

bindkey -M viins '^X' create_completion;
bindkey -M vicmd '^X' create_completion;

zinit light qoomon/zsh-lazyload
lazyload kubecolor -- 'source <(kubectl completion zsh);compdef kubecolor="kubectl"'
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"


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
  zdharma-continuum/null \
  ;

zinit wait"1" lucid as"program" for \
    cp"wd.sh -> wd" mv"_wd.sh -> _wd" \
    atpull"!git reset --hard" pick"wd" \
  mfaerevaag/wd \
    id-as"git-unique" pick"git-unique" \
  Osse/git-scripts \
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
  ;

zinit lucid for \
    make"!" atclone"./direnv hook zsh > zhook.zsh" \
    atpull"%atclone" src"zhook.zsh" \
  direnv/direnv \
  ;



# FIXME: per-directory-historyと干渉している
# 以下のコマンドでhookを削除すると使えるようになる
# add-zsh-hook -d zshaddhistory _per-directory-history-addhistory
# zinit light akash329d/zsh-alias-finder
# zinit ice src="alias-finder.plugin.zsh"
# zinit snippet OMZ::plugins/alias-finder/alias-finder.plugin.zsh
# zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
# zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
# zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
# zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# zinit light akash329d/zsh-alias-finder
# zi ice wait lucid \
#   pick'auto-fu.zsh'
# zinit light hchbaw/auto-fu.zsh 


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


# Bash Line Editor
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
# zinit light romkatv/zsh-no-ps2
# zinit light deyvisonrocha/pantheon-terminal-notify-zsh-plugin # for x server







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




# can define alias as yaml
# zinit blockf light-mode as"program" from"gh-r" for \
#     atload'eval "$(zabrze init --bind-keys)"' \
#     Ryooooooga/zabrze
# ~/.config/zabrze/config.yaml
  


# zinit ice wait lucid src'ls-colors.zsh'
# zinit load 'xPMo/zsh-ls-colors'


