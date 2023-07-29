export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export FZF_TMUX_OPTS="-p 80%"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups

## zsh-vi-mode

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

## Tmux pane slector
function tmux_left_pane() {
	tmux select-pane -L
}
function tmux_down_pane() {
	tmux select-pane -D
}
function tmux_up_pane() {
	tmux select-pane -U
}
function tmux_right_pane() {
	tmux select-pane -R
}
function tmux_split_pane() {
	tmux select-pane -R
}
function tmux_vsplit() {
	tmux split-window -h
}
function tmux_split() {
	tmux split-window -v
}
function tmux_pane_select_zvm_keybind() {
	zvm_define_widget tmux_left_pane
	zvm_define_widget tmux_down_pane
	zvm_define_widget tmux_up_pane
	zvm_define_widget tmux_right_pane
	
	zvm_define_widget tmux_vsplit
	zvm_define_widget tmux_split
	# move
	zvm_bindkey vicmd '^Wh' tmux_left_pane
	zvm_bindkey vicmd '^Wj' tmux_down_pane
	zvm_bindkey vicmd '^Wk' tmux_up_pane
	zvm_bindkey vicmd '^Wl' tmux_right_pane

	# split
	zvm_bindkey vicmd '^Wv' tmux_vsplit
	zvm_bindkey vicmd '^Ws' tmux_split
}

function q() {
	exit 1
}
function tmux_search_up_mode() {
	tmux copy && tmux send-keys ?
}

function tmux_half_page_up () {
	tmux copy && tmux send-keys ^U
}
function tmux_half_page_down () {
	tmux copy && tmux send-keys ^D
}

function tmux_page_scroll_zvm_keybind() {
	zvm_define_widget tmux_half_page_up
	zvm_define_widget tmux_half_page_down
	
	zvm_bindkey vicmd '^U' tmux_half_page_up
	zvm_bindkey vicmd '^D' tmux_half_page_down
}
## fzf vi
function fzf_vi() {
	vi $(git ls-files $(git rev-parse --git-dir)/.. | fzf)
}
function fzf_vi_keybind() {
	zvm_define_widget fzf_vi
	zvm_bindkey vicmd 'fg' fzf_vi
}

## initial zvm
function zvm_after_lazy_keybindings() {
	# keybind functions
	tmux_pane_select_zvm_keybind
	tmux_page_scroll_zvm_keybind
	fzf_vi_keybind
	
	
	zvm_define_widget q # quit command
	
	zvm_define_widget tmux_search_up_mode
	
	zvm_bindkey vicmd '/' tmux_search_up_mode

	zvm_bindkey vicmd '^G' fzf-z-search
}
