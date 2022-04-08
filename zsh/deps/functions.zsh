#!/usr/bin/env bash

# Run given command in each subdirectory
function eachdir() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: eachdir <command> [<depth=1>]"
    return 1
  fi

  find . -maxdepth "${2:-1}" -type d \( ! -name . \) -exec zsh -c "source ~/.zshrc && cd '{}' && pwd && $1" \;
}

# No arguments: `git status`
# With arguments: acts like `git`
function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}

# Sync forked git repo
function sync() {
  if [[ ! -d .git ]]; then
    echo "Not a git repository."
    return 1
  fi

  git fetch upstream && \
  git checkout master && \
  git merge upstream/master && \
  git push
}

function clone() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: git clone <repo>"
    return 1
  fi

  git clone "$@"
}

# Pull git repo (stash local changes)
function pull() {
  if [[ ! -d .git ]]; then
    echo "Not a git repository."
    return 1
  fi
  
  git stash push --include-untracked --quiet && \
  git pull --rebase && \
  git remote prune origin && \
  git stash pop --quiet
}

# Install Node and PHP dependencies
function installdeps() {
  if [ -f "package.json" ]; then
    if [ -x "$(command -v yarn)" ]; then
      yarn install
    else
      npm install
    fi
  fi

  if [ -f "composer.json" ]; then
    composer install --ignore-platform-reqs
  fi
}

# Bump Node and PHP dependencies
function bumpdeps() {
  if [ -f "package.json" ]; then
    if [ -x "$(command -v yarn)" ]; then
      yarn update
    else
      npm update
    fi
  fi

  if [ -f "composer.json" ]; then
    composer update
  fi
}

# Load .env file into shell session for environment variables
function envup() {
  if [ -f .env ]; then
    export $(sed '/^ *#/ d' .env)
  else
    echo 'No .env file found' 1>&2
    return 1
  fi
}

function upgrade() {
  # System updates
  if is_macos; then
    sudo softwareupdate -i -a
  fi
  if is_linux; then
    sudo apt update && sudo apt upgrade -y
  fi

  # Update Homebrew (Cask) & packages
  if [ -x "$(command -v brew)" ]; then
    brew update
    brew upgrade
  fi
  
  # Update npm & packages
  if [ -x "$(command -v npm)" ]; then
    npm install npm -g
    npm update -g
  fi
  
  # Update Ruby & gems
  if [ -x "$(command -v gem)" ]; then
    gem update —system
    gem update
  fi
  
  # Update Composer packages
  if [ -x "$(command -v composer)" ]; then
    composer global update
  fi
  
  # Update Python packages
  if [ -x "$(command -v pip3)" ]; then  
    pip3 install --upgrade pip setuptools
  fi
  if [ -x "$(command -v pipx)" ]; then
    pipx upgrade-all
  fi

  # rm -rf $GOPATH/src/*

  git -C "$ZSH_CUSTOM/themes/powerlevel10k" pull

  # git -C "$DOTFILES" pull
}

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}
