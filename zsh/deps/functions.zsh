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

function gwr() {
  git worktree remove "$1" && git branch -D "$1"
}

function gwrf() {
  git worktree remove --force "$1" && git branch -D "$1"
}

function gwa() {
  # Validate arguments
  if [[ $# -eq 0 ]]; then
    e_error "Usage: gwa <path> [<branch>]"
    return 1
  fi

  local worktree_path="$1"
  local branch_arg="${2}"

  # Create the worktree
  e_arrow "Creating worktree at: $worktree_path"
  if ! git worktree add "$worktree_path" ${branch_arg:+"$branch_arg"}; then
    e_error "Failed to create worktree"
    return 1
  fi

  e_success "Worktree created successfully"

  # Navigate to the new worktree
  cd "$worktree_path" || {
    e_error "Failed to navigate to worktree directory: $worktree_path"
    return 1
  }

  # Check if this is a Rails project
  if [[ ! -d "config/credentials" ]]; then
    e_arrow "Not a Rails project (no config/credentials/), skipping Rails setup"
    return 0
  fi

  e_arrow "Rails project detected, setting up credentials and MCP..."

  # Determine source worktree (prefer master, fallback to main)
  local source_worktree=""
  if [[ -d "../master/config" ]]; then
    source_worktree="../master"
  elif [[ -d "../main/config" ]]; then
    source_worktree="../main"
  else
    e_error "Could not find source worktree (checked ../master and ../main)"
    e_error "Please ensure you have a 'master' or 'main' worktree with credentials"
    return 1
  fi

  # Verify source files exist
  local creds_dir="${source_worktree}/config/credentials"
  local master_key="${source_worktree}/config/master.key"

  # Check for development credentials (both key and encrypted file)
  if [[ ! -f "$creds_dir/development.key" ]] || [[ ! -f "$creds_dir/development.yml.enc" ]]; then
    e_error "Development credentials not found in: $creds_dir"
    e_error "Expected: development.key and development.yml.enc"
    return 1
  fi

  # Check for master key
  if [[ ! -f "$master_key" ]]; then
    e_error "Master key not found: $master_key"
    return 1
  fi

  # Copy development credentials
  e_arrow "Copying development credentials from ${source_worktree}..."
  if ! cp "$creds_dir"/development.* config/credentials/; then
    e_error "Failed to copy development credentials"
    return 1
  fi
  e_success "Development credentials copied"

  # Copy master key
  e_arrow "Copying master.key from ${source_worktree}..."
  if ! cp "$master_key" config/; then
    e_error "Failed to copy master.key"
    return 1
  fi
  e_success "Master key copied"

  # Add playwright MCP server
  e_arrow "Adding Playwright MCP server..."
  if ! claude mcp add playwright npx @playwright/mcp@latest; then
    e_error "Failed to add Playwright MCP server"
    return 1
  fi
  e_success "Playwright MCP server added"

  e_success "Rails worktree setup complete!"
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

# Install Node and PHP dependencies
function installdeps() {
  if [ -f "package.json" ]; then
    if command -v yarn &>/dev/null; then
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
    if command -v yarn &>/dev/null; then
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
  if command -v brew &>/dev/null; then
    brew update
    brew upgrade
  fi

  # Update npm & packages
  if command -v npm &>/dev/null; then
    npm install npm@latest -g
    npm update -g
  fi

  # Update Ruby & gems
  if command -v gem &>/dev/null; then
    gem update —system
    gem update
  fi

  # Update Composer packages
  if command -v composer &>/dev/null; then
    composer global update
  fi

  # Update uv tools
  if command -v uv &>/dev/null; then
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