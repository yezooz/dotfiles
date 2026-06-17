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

# Git worktree add with automatic project setup
function gwa() {
  # Validate arguments
  if [[ $# -eq 0 ]]; then
    e_error "Usage: gwa <path> [<branch>]"
    return 1
  fi

  local worktree_path="$1"
  local branch_arg="${2}"

  # Resolve the branch into a ref `git worktree add` can use.
  # `git worktree add <path> <branch>` only accepts a branch the local repo
  # already knows, so resolve cheaply (local -> remote-tracking) before falling
  # back to the network (exists on origin but not fetched), and error if the
  # branch exists nowhere.
  local -a wt_args
  if [[ -z "$branch_arg" ]]; then
    wt_args=("$worktree_path")
  elif git show-ref --verify --quiet "refs/heads/$branch_arg"; then
    wt_args=("$worktree_path" "$branch_arg")
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch_arg"; then
    wt_args=(-b "$branch_arg" "$worktree_path" "origin/$branch_arg")
  elif git ls-remote --exit-code --heads origin "$branch_arg" >/dev/null 2>&1; then
    e_arrow "Fetching $branch_arg from origin..."
    # Fetch with an explicit refspec so the remote-tracking ref is created even
    # when origin has no configured fetch refspec (otherwise only FETCH_HEAD is
    # written and `origin/$branch_arg` stays unresolvable).
    if ! git fetch origin "${branch_arg}:refs/remotes/origin/${branch_arg}"; then
      e_error "Failed to fetch $branch_arg"
      return 1
    fi
    wt_args=(-b "$branch_arg" "$worktree_path" "origin/$branch_arg")
  else
    e_error "Branch '$branch_arg' not found locally or on origin"
    return 1
  fi

  # Create the worktree
  e_arrow "Creating worktree at: $worktree_path"
  if ! git worktree add "${wt_args[@]}"; then
    e_error "Failed to create worktree"
    return 1
  fi

  e_success "Worktree created successfully"

  # Navigate to the new worktree
  cd "$worktree_path" || {
    e_error "Failed to navigate to worktree directory: $worktree_path"
    return 1
  }

  # Auto-detect project type and run setup
  _worktree_auto_setup
}

# Auto-detect and run project-specific setup
function _worktree_auto_setup() {
  if _is_rails_project; then
    _worktree_setup_rails
  fi
  # Add more project types here as needed:
  # elif _is_node_project; then
  #   _worktree_setup_node
  # fi
}

# Check if current directory is a Rails project
function _is_rails_project() {
  [[ -d "config/credentials" ]] && [[ -f "Gemfile" ]]
}

# Rails-specific worktree setup
function _worktree_setup_rails() {
  e_arrow "Rails project detected, setting up credentials..."

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

  # Optional: Add MCP server (only if claude CLI exists)
  _worktree_setup_mcp

  e_success "Rails worktree setup complete!"
}

# MCP setup (optional, only runs if claude CLI exists)
function _worktree_setup_mcp() {
  if command -v claude &>/dev/null; then
    e_arrow "Adding Playwright MCP server..."
    if claude mcp add playwright npx @playwright/mcp@latest 2>/dev/null; then
      e_success "Playwright MCP server added"
    else
      e_arrow "MCP server setup skipped (non-critical)"
    fi
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

# Check dotfiles health and configuration
function dotfiles-health() {
  e_header "Dotfiles Health Check"

  local errors=0

  # Check DOTFILES directory
  if [[ -d "$DOTFILES" ]]; then
    e_success "DOTFILES directory: $DOTFILES"
  else
    e_error "DOTFILES directory not found: $DOTFILES"
    ((errors++))
  fi

  # Check if all dependency files exist
  local missing_deps=()
  for dep in path.zsh exports.zsh aliases.zsh functions.zsh autocomplete.zsh bindkeys.zsh; do
    if [[ ! -f "$DOTFILES/zsh/deps/$dep" ]]; then
      missing_deps+="$dep"
    fi
  done

  if [[ ${#missing_deps} -eq 0 ]]; then
    e_success "All dependency files present (6 files)"
  else
    e_error "Missing dependency files: ${missing_deps[*]}"
    ((errors++))
  fi

  # Check for local overrides
  if [[ -f ~/.zshrc.local ]]; then
    e_success "Local overrides: ~/.zshrc.local found"
  else
    e_arrow "Local overrides: None (create ~/.zshrc.local for machine-specific settings)"
  fi

  # Check Oh-My-Zsh
  if [[ -d "$ZSH" ]]; then
    e_success "Oh-My-Zsh: $ZSH"
  else
    e_error "Oh-My-Zsh not found: $ZSH"
    ((errors++))
  fi

  # Check Powerlevel10k theme
  if [[ -f "$ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    e_success "Powerlevel10k theme installed"
  else
    e_error "Powerlevel10k theme not found"
    ((errors++))
  fi

  # Check critical tools
  local tools=(git vim tmux)
  is_macos && tools+=(brew)

  for tool in "${tools[@]}"; do
    if command -v "$tool" &>/dev/null; then
      e_success "Tool: $tool ($(command -v $tool))"
    else
      e_error "Tool not found: $tool"
      ((errors++))
    fi
  done

  # Check NVM
  if [[ -d "$NVM_DIR" ]]; then
    e_success "NVM directory: $NVM_DIR"
    if [[ "${NVM_LAZY_LOAD:-1}" == "1" ]]; then
      e_arrow "NVM lazy loading: Enabled (for performance)"
    else
      e_arrow "NVM lazy loading: Disabled (loads on shell startup)"
    fi
  else
    e_arrow "NVM not installed (optional)"
  fi

  # Performance check
  echo
  e_header "Performance"
  e_arrow "Run 'zsh-benchmark' to measure shell startup time"
  e_arrow "Run 'zsh-profile' to profile startup performance"
  e_arrow "Target: < 300ms startup time"

  # Summary
  echo
  if [[ $errors -eq 0 ]]; then
    e_success "Health check passed! No issues found."
    return 0
  else
    e_error "Health check failed with $errors error(s)"
    return 1
  fi
}

# Shorter alias
alias dfh='dotfiles-health'