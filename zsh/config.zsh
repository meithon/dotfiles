export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export FZF_TMUX_OPTS="-p 80%"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

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

# ## find function
# function fzf-find-file() {
# 	find . -type f | fzf-tmux \
# 		--preview 'bat --color "always" {}' 
# }
# function fzf-find-file-keybing() {
# 	zvm_define_widget fzf-find-file
# 	zvm_bindkey vicmd 'ff' fzf-find-file
# }

## initial zvm
function zvm_after_lazy_keybindings() {
	# keybind functions
	tmux_pane_select_zvm_keybind
	tmux_page_scroll_zvm_keybind
	fzf_vi_keybind
	# fzf-find-file-keybing
	
	
	zvm_define_widget q # quit command
	
	zvm_define_widget tmux_search_up_mode
	
	zvm_bindkey vicmd '/' tmux_search_up_mode

	zvm_bindkey vicmd '^G' fzf-z-search
}
