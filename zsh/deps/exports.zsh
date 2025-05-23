#!/usr/bin/env bash

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#     export EDITOR="vim"
# else
#     export EDITOR="subl -w"
# fi

export EDITOR="vim"
export COLORTERM="truecolor"
export MANPATH="/usr/local/man:$MANPATH"

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
# export GPG_TTY=$(tty)

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

export SSH_KEY_PATH="$HOME/.ssh/dsa_id"

export HOMEBREW_NO_ANALYTICS=1
# export BREW_PREFIX=$(brew --prefix)

# export DOCKER_HOST='unix:///var/folders/36/0h73z8ws6xld1c38dxbh4_2h0000gn/T/podman/podman-machine-default-api.sock'
