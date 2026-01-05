#!/usr/bin/env bash

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

# Don't clear the screen after quitting a manual page.
export MANPAGER="less -X"

# Hide the "default interactive shell is now zsh" warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

export HOMEBREW_NO_ANALYTICS=1

# Default user for Powerlevel10k prompt (hides user@hostname when matching)
# Override in ~/.zshrc.local if needed
export DEFAULT_USER="${DEFAULT_USER:-$USER}"

# AWS Vault profile - Override in ~/.zshrc.local for work profiles
# export AWS_VAULT_PROFILE="${AWS_VAULT_PROFILE:-default}"

# Git configuration - Set your email address here
# This will be used by Git for commits and authoring
# Uncomment and set your email address:
# export USER_EMAIL="your.email@example.com"
# export GIT_AUTHOR_EMAIL="$USER_EMAIL"
# export GIT_COMMITTER_EMAIL="$USER_EMAIL"

# NVM (Node Version Manager) - Lazy Loaded for Performance
# Loading NVM synchronously adds ~300-500ms to shell startup.
# We use lazy loading: NVM initializes only when you first run
# node, npm, npx, or nvm commands, providing instant shell startup.
# To force immediate load: nvm --version
# To disable lazy loading: export NVM_LAZY_LOAD=0
export NVM_DIR="$HOME/.nvm"

# Check if lazy loading is disabled
if [[ "${NVM_LAZY_LOAD:-1}" == "0" ]]; then
  # Load NVM immediately (old behavior)
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
else
  # Lazy load NVM on first use (~300-500ms savings)
  _load_nvm() {
    # Remove wrapper functions
    unset -f node npm npx nvm _load_nvm

    # Load NVM
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  }

  # Wrapper functions that trigger NVM loading on first use
  node() { _load_nvm && node "$@" }
  npm() { _load_nvm && npm "$@" }
  npx() { _load_nvm && npx "$@" }
  nvm() { _load_nvm && nvm "$@" }
fi