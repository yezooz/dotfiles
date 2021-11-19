export SHELL=/bin/zsh
if [ -t 1 ]; then exec $SHELL; fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH=/usr/local/bin:/usr/local/opt/php@7.4/bin:$PATH

# Direnv
eval "$(direnv hook bash)"
