#!/usr/bin/env bash

typeset -U path fpath

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"

fpath+="$HOME/.zfunc"

# OS Detection
if [[ $(uname) == "Darwin" ]]; then
  export MACOS=1
  fpath+="$(brew --prefix)/share/zsh/site-functions"
elif [[ $(uname) == "Linux" ]]; then
  export LINUX=1
fi

# Create a cache folder if it isn't exists
if [ ! -d "$HOME/.cache/zsh" ]; then
    mkdir -p $HOME/.cache/zsh
fi

# export ZPLUG_HOME=$HOME/.zplug
# [ ! -d "$ZPLUG_HOME" ] && mkdir -p "$ZPLUG_HOME"
# export ZPLUG_BIN=$ZPLUG_HOME/bin
# [ ! -d "$ZPLUG_BIN" ] && mkdir -p "$ZPLUG_BIN"

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Make sure to use double quotes
# zplug "zsh-users/zsh-history-substring-search"

# Grab binaries from GitHub Releases
# and rename with the "rename-to:" tag
# zplug "junegunn/fzf-bin", \
#     from:gh-r, \
#     as:command, \
#     rename-to:fzf, \
#     use:"*darwin*amd64*"

# Supports oh-my-zsh plugins and the like
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/aliases", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/cp", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/zsh-nvm", from:oh-my-zsh
# https://github.com/blimmer/zsh-aws-vault
zplug "plugins/zsh-aws-vault", from:oh-my-zsh

# https://github.com/apachler/zsh-aws
zplug "apachler/zsh-aws"

# https://github.com/zpm-zsh/clipboard
zplug "zpm-zsh/clipboard"
# https://github.com/arzzen/calc.plugin.zsh
zplug "arzzen/calc.plugin.zsh"
# https://github.com/D3STY/cros-auto-notify-zsh
zplug "D3STY/cros-auto-notify-zsh"
# https://github.com/ptavares/zsh-direnv
zplug "ptavares/zsh-direnv"
# https://github.com/ytakahashi/igit
# zplug "ytakahashi/igit"
# zplug "lukechilds/zsh-nvm"

# Can manage local plugins
zplug "~/dotfiles/zsh/plugins", from:local

# Load theme file
# zplug 'agnoster', as:theme
# zplug 'powerlevel10k/powerlevel10k', as:theme

# Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi

# Then, source plugins and add commands to $PATH
# zplug load --verbose