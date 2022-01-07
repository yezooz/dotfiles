#!/usr/bin/env bash

export SHELL=/bin/zsh

if [ -t 1 ]; then exec $SHELL; fi

export PATH=/usr/local/bin:$PATH

# Direnv
# eval "$(direnv hook bash)"

[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

eval "$(starship init bash)"

# [ -n "$PS1" ] && source ~/.bash_profile;