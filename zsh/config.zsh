export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export FZF_TMUX_OPTS="-p 80%"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
