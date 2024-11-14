# Enable Powerlevel10k instant prompt. Should stay close to the top of ./.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"
source "${ZI[BIN_DIR]}/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi


# zi ice svn
# zi snippet OMZP::history-substring-search
zi light zsh-users/zsh-syntax-highlighting

zi ice blockf
zi light zsh-users/zsh-completions


# zi ice svn silent wait'!1' atload'prompt smiley'
# zi snippet PZT::modules/prompt
w
zi ice depth"1"
zi light romkatv/powerlevel10k
zi as 'theme' for romkatv/powerlevel10k


zi ice wait lucid
zi load z-shell/H-S-MW

zi ice wait lucid atload'!_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

zi ice from"gh-r" as"program"
zi light junegunn/fzf


zi ice wait lucid as'program' cp'wd.sh -> wd' \
  mv'_wd.sh -> _wd' atpull'!git reset --hard' pick'wd'
zi light mfaerevaag/wd

zi ice as'program' id-as'git-unique' pick'git-unique'
zi snippet https://github.com/Osse/git-scripts/blob/master/git-unique

zi ice wait lucid as'program' pick'bin/git-dsf'
zi load z-shell/zsh-diff-so-fancy

zi ice lucid wait as'program' has'bat' pick'src/*'
zi light eth-p/bat-extras

zi ice lucid wait as'program' has'git' \
  atclone"cp git-open.1.md $ZI[MAN_DIR]/man1/git-open.1" atpull'%atclone'
zi light paulirish/git-open

zi ice lucid wait as'program' atclone"cp hr.1 $ZI[MAN_DIR]/man1" atpull'%atclone'
zi light LuRsT/hr

zi ice lucid wait as'program' has'gpg'
zi light dylanaraps/pash

# To customize prompt, run `p10k configure` or edit ./.p10k.zsh.
[[ ! -f ./.p10k.zsh ]] || source ./.p10k.zsh


############
# export PASH_DIR=~/.local/share/pash
# export PASH_LENGTH=50
# export PASH_PATTERN=_A-Z-a-z-0-9
read -r PASH_KEYID < "$PASH_DIR/.gpg-id"
export PASH_CLIP='pbcopy'
pash() {
    case $1 in
        g*)
            cd "${PASH_DIR:=${XDG_DATA_HOME:=$HOME/.local/share}/pash}"
            shift
            git "$@"
        ;;

        *)
            command pash "$@"
        ;;
    esac
}
