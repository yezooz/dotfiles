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

# mise (https://mise.jdx.dev) - polyglot runtime manager for Node, Python, etc.
# Replaces NVM. Chosen because it is Homebrew-prefix-agnostic (works identically
# on Intel /usr/local and Apple Silicon /opt/homebrew), fast enough to activate
# eagerly (no lazy-load hack needed), and manages the Node version per-repo via
# .mise.toml / .tool-versions plus a global default in ~/.config/mise/config.toml.
# Install: brew install mise   |   Set global Node: mise use -g node@22
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi
