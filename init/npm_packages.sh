#!/usr/bin/env bash

################################################################################
# NPM Global Packages Installation
################################################################################
# Installs globally used NPM packages
# Requires Node.js/npm to be installed first
################################################################################

set -e

# Source the dotfiles script for helper functions
DOTFILES_DIR="${HOME}/.dotfiles"
source "${DOTFILES_DIR}/bin/dotfiles"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    e_error "npm is not installed. Please install Node.js first."
    exit 1
fi

e_header "Installing NPM Global Packages"

# Configure npm to use a custom global directory to avoid permission issues
NPM_GLOBAL_DIR="${HOME}/.npm-global"
if [[ ! -d "$NPM_GLOBAL_DIR" ]]; then
    e_arrow "Configuring npm global directory: $NPM_GLOBAL_DIR"
    mkdir -p "$NPM_GLOBAL_DIR"
    npm config set prefix "$NPM_GLOBAL_DIR"
fi

# Ensure the global bin directory is in PATH
if [[ ":$PATH:" != *":$NPM_GLOBAL_DIR/bin:"* ]]; then
    e_arrow "Note: Add $NPM_GLOBAL_DIR/bin to your PATH"
    echo "export PATH=\"\$PATH:$NPM_GLOBAL_DIR/bin\"" >> ~/.zshrc
fi

# Update npm itself
e_arrow "Updating npm"
npm install -g npm@latest

# Install global packages
e_arrow "Installing global NPM packages"

# AI & Development Tools
npm install -g @openai/codex         # OpenAI Codex CLI
npm install -g @playwright/mcp       # Playwright MCP server

# Package Management
npm install -g yarn                  # Alternative package manager

e_success "NPM global packages installation complete!"

echo ""
e_arrow "Installed packages:"
npm list -g --depth=0
