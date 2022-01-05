export SHELL=/bin/zsh

if [ -t 1 ]; then exec $SHELL; fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH=/usr/local/bin:$PATH

# Direnv
eval "$(direnv hook bash)"

# [ -n "$PS1" ] && source ~/.bash_profile;