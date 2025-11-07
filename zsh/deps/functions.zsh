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
# Safely parses .env files without executing arbitrary code
function envup() {
  if [ -f .env ]; then
    # Parse .env file line by line, validating each entry
    while IFS= read -r line || [ -n "$line" ]; do
      # Skip empty lines and comments
      [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

      # Validate line format (KEY=VALUE)
      if [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        local key="${BASH_REMATCH[1]}"
        local value="${BASH_REMATCH[2]}"

        # Remove surrounding quotes if present
        value="${value%\"}"
        value="${value#\"}"
        value="${value%\'}"
        value="${value#\'}"

        # Export the variable safely
        export "$key=$value"
      else
        echo "⚠️  Skipping invalid line: $line" 1>&2
      fi
    done < .env
    echo "✓ Environment variables loaded from .env"
  else
    echo '✗ No .env file found' 1>&2
    return 1
  fi
}

function upgrade() {
  # System updates
  # if is_macos; then
  #   sudo softwareupdate -i -a
  #   # mas upgrade
  # fi
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
    npm install npm@latest -g
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

  # Update uv tools
  if [ -x "$(command -v uv)" ]; then
    uv tool upgrade --all
  fi

  git -C "$ZSH_CUSTOM/themes/powerlevel10k" pull

  # git -C "$DOTFILES" pull
}

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# Boop; plays a happy sound if the previous command exited successfully 
# (i.e., exited with status code 0) and a sad sound otherwise.
function boop () {
   local last="$?"
   if [[ "$last" == '0' ]]; then
     afplay /System/Library/Sounds/Glass.aiff
   else
     afplay /System/Library/Sounds/Submarine.aiff
   fi
   $(exit "$last")
}