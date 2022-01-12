#!/usr/bin/env bash

typeset -U path fpath

export EDITOR="vim"
export COLORTERM="truecolor"
export MANPATH="/usr/local/man:$MANPATH"

fpath+="$HOME/.zfunc"

path=($DOTFILES/bin $path)

if [[ $(uname) == "Darwin" ]]; then
  export MACOS=1

  export BREW_PREFIX=$(brew --prefix)
  fpath+="$BREW_PREFIX/share/zsh/site-functions"

  # Preferred editor for local and remote sessions
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="vim"
  else
    export EDITOR="subl -w"
  fi

elif [[ $(uname) == "Linux" ]]; then
  export LINUX=1

  path=(~/.linuxbrew/bin $path)

  export BREW_PREFIX=$(brew --prefix)
  fpath+="$BREW_PREFIX/share/zsh/site-functions"

  export GNU_USERLAND=1

  # Make vim the default editor.
  export EDITOR="vim"
  export TERMINAL="terminator"
fi

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY="$HOME/.node_history"
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE="32768"
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE="sloppy"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'

# Prefer US English and use UTF-8.
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less -X"

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty)

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

export SSH_KEY_PATH="$HOME/.ssh/dsa_id"

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
