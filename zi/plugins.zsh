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


autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
#
# # zi ice svn
# # zi snippet OMZP::history-substring-search
# zi light zsh-users/zsh-syntax-highlighting
#
# zi ice blockf
# zi light zsh-users/zsh-completions


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




# zi ice wait lucid atload'!_zsh_autosuggest_start'
# zi light zsh-users/zsh-autosuggestions

zinit wait"1" lucid as"program" for \
    from"gh-r" \
  junegunn/fzf \
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
  direnv/direnv \
    from"gh-r" pick"zoxide" \
    atclone"./zoxide init zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" \
  ajeetdsouza/zoxide

zi ice wait"1" lucid
zi light sunlei/zsh-ssh

# ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# ZVM_VI_ESCAPE_BINDKEY=jk
# ZVM_VI_INSERT_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
# ZVM_VI_VISUAL_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
# ZVM_VI_OPPEND_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY

# function zvm_config() {
#   ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
#   ZVM_VI_ESCAPE_BINDKEY=jk
#   ZVM_VI_INSERT_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
#   ZVM_VI_VISUAL_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
#   ZVM_VI_OPPEND_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
# }
# Essential plugins
# zi light romkatv/zsh-defer
# zi light mafredri/zsh-async
zinit wait lucid for \
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
    atload'export PER_DIRECTORY_HISTORY_TOGGLE=^V' \
  jimhester/per-directory-history \
  Aloxaf/fzf-tab

# nulls
zinit wait lucid for \
    has'asdf' atload'source ~/dotfiles/shell/envsetup.sh' \
  zdharma-continuum/null \
    has"thefuck" atload'eval $(thefuck --alias fk)' \
  zdharma-continuum/null \
    has"bun" atload'[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
           export BUN_INSTALL="$HOME/.bun"
           export PATH="$BUN_INSTALL/bin:$PATH"' \
  zdharma-continuum/null


zi ice wait lucid \
    atload"
      abbrev-alias -g -e \"it=\$(history | tail -n 1 | awk '{print \$NF}')\"
    " \
zi light momo-lab/zsh-abbrev-alias





