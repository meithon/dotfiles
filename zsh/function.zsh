function curl-post() {
    ENDPOINT="${1}"

    JSON="${2}"
    curl -X POST -H "Content-Type: application/json" -d "${JSON}" "${ENDPOINT}"
}

function fzf-history-search() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N fzf-history-search
bindkey '^r' fzf-history-search

# zplugなどでzをインストールしとく
# zplug "rupa/z", use:z.sh

fzf-z-search() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}

zle -N fzf-z-search
bindkey '^g' fzf-z-search


function frm() {
    local selected
    selected=$(unbuffer lsd -l | fzf -m --ansi | awk '{print $12}')
    if [[ -n "$selected" ]]; then
        selected=$(tr '\n' ' ' <<< "$selected")
        rm $selected
    fi
}

function fzf-git-add() {
    local selected
    selected=$(unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '{print \$2}' | xargs git diff --color" | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        selected=$(tr '\n' ' ' <<< "$selected")
        git add $selected
    fi
}


## kuber
function get-name() {
 awk '{print $1}' | tail -n +2
}
function get-crd-name(){
	kubectl get crd | get-name | fzf
}
function get-crd(){
	kubectl get crd
}
function get-ns() {
	kubectl get ns | awk '{print $1}' | tail -n +2 | fzf
}

function show-crd(){
	kubectl get $(get-crd) -o yaml
}

function get-cr-with-namespaced() {
	
}

function show-cr-list() {
	kubectl get $(get-crd) --all-namespaces
}

function get-ns() {
	 awk '{print $1} ' | tail -n +2 | uniq
}

function get-cr-list-ns() {
	local crd
	crd=$(get-crd-name)
	kubectl get $crd -n $(kubectl get $crd --all-namespaces |  get-ns)
}


# function zshaddhistory() {
# 	history_item="${${1%%$'\n'}%%$' ###'*} ### ${PWD}"
#   print -sr ${(z)history_item}
#   fc -p
#   return 1
# }
#
function fzf-kill-process() {
	ps -u $USER -o pid,stat,cputime,command | \
		sed 1d | \
		fzf-tmux| \
		awk '{print $1}' | \
		xargs kill 
}

function _fzf-find-file() {
  local file
  file=$(find . -type f | fzf-tmux --preview 'bat --color "always" {}')
  if [ -n "$file" ]; then
    LBUFFER+="$file"
  fi
  zle reset-prompt
}

zle -N _fzf-find-file
bindkey -v "^t" _fzf-find-file 

alias f="find . -type f | fzf-tmux --preview 'bat --color "always" {}'"

function find-git-file() {
		# 現在のディレクトリからGitリポジトリのルートまでの相対パスを取得
	REL_PATH=$(git rev-parse --show-prefix)

	# fzfで表示する際に相対パスを取り除き、選択した結果に相対パスを追加
	git -C $(git rev-parse --show-toplevel) ls-files | awk -v rel="$REL_PATH" '{gsub("^"rel, "", $0); print}' | fzf | awk -v rel="$REL_PATH" '{print rel $0}'
}

function z-readonly() {
	#!/bin/bash

	input_file="$HOME/.z"

	while IFS= read -r line
	do
			echo "$line" | cut -d'|' -f1
	done < "$input_file"

}

#it used by tmux.conf
relative-path () {
	source=$1
	target=$2

	common_part=$source
	back=
	while [ "${target#$common_part}" = "${target}" ]; do
		common_part=$(dirname $common_part)
		back="../${back}"
	done

	echo ${back}${target#$common_part/}
}
get-path-from-tmux-status() {
	arg="$1"
	echo "$arg" | sed -E 's@^(/[^[:space:]]+).*@\1@'
}
get-tmux-current-dir(){
	tmux display-message -p "#{session_path}"
}
relative-current-dir-for-tmux(){
	relative-path $(get-tmux-current-dir) $(pwd)
}


function tmux-switch ()
{
	tmux switch -t "$(tmux lsp -a -F "#{session_name}:#{window_name}" |fzf --preview 'tmux capture-pane -pe -t {}')"
}
zle -N tmux-switch
bindkey '^j' tmux-switch

