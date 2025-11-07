#!/usr/bin/env bash

################################################################################
# UV Python Tools Installation
################################################################################
# Installs Python tools via UV (modern Python package installer)
# UV provides isolated environments for Python CLI tools
################################################################################

set -e

# Source the dotfiles script for helper functions
DOTFILES_DIR="${HOME}/.dotfiles"
source "${DOTFILES_DIR}/bin/dotfiles"

# Check if uv is installed, if not install it
if ! command -v uv &> /dev/null; then
    e_arrow "UV not found, installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Source the UV installation
    source "$HOME/.local/bin/env"
fi

e_header "Installing UV Python Tools"

# AI & LLM Tools
e_arrow "AI & LLM Tools"
uv tool install llm                  # Simon Willison's LLM CLI interface

# Development Tools
e_arrow "Development Tools"
uv tool install poetry               # Python dependency management
uv tool install pre-commit           # Git pre-commit hooks

# Web Scraping
e_arrow "Web Scraping Tools"
uv tool install scrapy               # Web scraping framework

# Git Utilities
e_arrow "Git Utilities"
uv tool install git-filter-repo      # Git repository rewriting tool

e_success "UV Python tools installation complete!"

echo ""
e_arrow "Installed UV tools:"
uv tool list
