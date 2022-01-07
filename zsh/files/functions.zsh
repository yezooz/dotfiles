#!/usr/bin/env bash

# No arguments: `git status`
# With arguments: acts like `git`
function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
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

function syncforks() {
	find . -maxdepth "${1:-1}" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -d '.git' ] && pwd && git fetch upstream && git checkout master && git merge upstream/master && git push" \;
}

function updeps() {
	# find . -maxdepth "${1:-1}" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -d '.git' ] && pwd && git stash push --include-untracked --quiet && git pr && git stash pop --quiet" \;
	find . -maxdepth "${1:-1}" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -d '.git' ] && pwd && git pull" \;
}

function installdeps() {
	local level="${1:-1}"

	upall
	find . -maxdepth "$level" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -f 'composer.json' ] && pwd && composer install --ignore-platform-reqs" \;
	find . -maxdepth "$level" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -f 'package.json' ] && pwd && npm install" \;
}

# function bumpall() {
# 	local level="${1:-1}"

# 	upall
# 	find . -maxdepth "$level" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -f 'composer.json' ] && pwd && composer update" \;
# 	find . -maxdepth "$level" -type d \( ! -name . \) -exec zsh -c "cd '{}' && [ -f 'package.json' ] && pwd && npm update" \;
# }

function upgrade() {
    # Update App Store apps
    sudo softwareupdate -i -a
    # Update Homebrew (Cask) & packages
    brew update
    brew upgrade
    # Update npm & packages
    npm install npm -g
    npm update -g
    # Update Ruby & gems
    gem update —system
    gem update
    # Update Composer packages
    composer global update
    # Update Python packages
    pip3 install --upgrade pip setuptools
    pipx upgrade-all

    git -C "$ZSH_CUSTOM/themes/powerlevel10k" pull
}

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}