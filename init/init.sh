#!/usr/bin/env bash

################################################################################
# Main Installation Script
################################################################################
# Orchestrates the installation process based on detected OS
# Uses configuration from .install-config if available
################################################################################

set -e

# Load dotfiles functions and environment
# source $DOTFILES/bin/dotfiles "source"
source ~/.dotfiles/bin/dotfiles

# Load installation config if it exists
CONFIG_FILE="${DOTFILES}/.install-config"
if [[ -f "$CONFIG_FILE" ]]; then
    e_header "Loading installation configuration..."
    source "$CONFIG_FILE"
    e_success "Configuration loaded"
fi

# Export configuration for child scripts
export DOTFILES
export USER_EMAIL
export USER_NAME
export INSTALL_PROFILE
export GENERATE_SSH
export APPLY_MACOS_DEFAULTS
export INSTALL_BREW_PACKAGES
export INSTALL_DEV_TOOLS
export INSTALL_DESKTOP_APPS
