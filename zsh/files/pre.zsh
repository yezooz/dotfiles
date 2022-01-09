#!/usr/bin/env bash

typeset -U path fpath

export EDITOR="vim"
export COLORTERM="truecolor"
export MANPATH="/usr/local/man:$MANPATH"
export DOTFILES="$HOME/.dotfiles"
path=($DOTFILES/bin ~/.linuxbrew/bin $path)

# fpath+="$HOME/.zfunc"

# OS Detection
if [[ $(uname) == "Darwin" ]]; then
  export MACOS=1
  fpath+="$(brew --prefix)/share/zsh/site-functions"
elif [[ $(uname) == "Linux" ]]; then
  export LINUX=1
  # fpath+="$(brew --prefix)/share/zsh/site-functions"
fi

# Create a cache folder if it isn't exists
if [ ! -d "$HOME/.cache/zsh" ]; then
    mkdir -p $HOME/.cache/zsh
fi

# export ZPLUG_HOME=$HOME/.zplug
# [ ! -d "$ZPLUG_HOME" ] && mkdir -p "$ZPLUG_HOME"
# export ZPLUG_BIN=$ZPLUG_HOME/bin
# [ ! -d "$ZPLUG_BIN" ] && mkdir -p "$ZPLUG_BIN"

# export ZPLUG_HOME=$(brew --prefix)/opt/zplug
# export ZPLUG_USE_CACHE=false

# source $ZPLUG_HOME/init.zsh

# source $DOTFILES/zsh/files/zplug.zsh

# Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi
# zplug check || zplug install

# Then, source plugins and add commands to $PATH
# zplug load --verbose
# zplug load
