#!/usr/bin/env bash

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
# zplug "plugins/z", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/aliases", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
# zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/cp", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh

# export NVM_DIR="$HOME/.nvm"
# export NVM_COMPLETION=true
# export NVM_LAZY_LOAD=true
# zplug "lukechilds/zsh-nvm", from:github, use:"zsh-nvm.plugin.zsh"
# zplug "plugins/zsh-nvm", from:oh-my-zsh

# https://github.com/blimmer/zsh-aws-vault
# zplug "plugins/zsh-aws-vault", from:oh-my-zsh

# https://github.com/zpm-zsh/colors
zplug "zpm-zsh/colors"

# https://github.com/apachler/zsh-aws
# zplug "apachler/zsh-aws"

# https://github.com/zpm-zsh/clipboard
zplug "zpm-zsh/clipboard"
# https://github.com/arzzen/calc.plugin.zsh
zplug "arzzen/calc.plugin.zsh"
# https://github.com/D3STY/cros-auto-notify-zsh
zplug "D3STY/cros-auto-notify-zsh"
# https://github.com/ptavares/zsh-direnv
# zplug "ptavares/zsh-direnv"
# https://github.com/ytakahashi/igit
# zplug "ytakahashi/igit"

zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Can manage local plugins
zplug "$ZSH_CUSTOM/plugins", from:local

# Load theme file
# zplug 'agnoster', as:theme
# zplug 'powerlevel10k', as:theme

# zplug "spaceship-prompt/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# zplug "mafredri/zsh-async", from:github
# zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme