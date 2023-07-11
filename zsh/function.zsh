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

# fzf-cdr
function fzf-cdr() {
    target_dir=$(unbuffer lsd -l | fzf --ansi | awk '{print $12}')
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}

function fzf-cdr-all() {
    target_dir=$(unbuffer lsd -la | fzf --ansi | awk '{print $12}')
    if [ -n "$target_dir" ]; then
        cd $target_dir
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
