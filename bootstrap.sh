#!/usr/bin/env bash

################################################################################
# Bootstrap Script for Dotfiles Installation
################################################################################
# This script can be run directly from GitHub:
# bash <(curl -fsSL https://raw.githubusercontent.com/yezooz/dotfiles/main/bootstrap.sh)
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✖${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Cleanup function
cleanup() {
    if [ $? -ne 0 ]; then
        log_error "Installation failed. Check the errors above."
        log_info "You can retry by running: cd ~/.dotfiles && /bin/bash init/init.sh"
    fi
}

trap cleanup EXIT

# Main installation
main() {
    log_header "Dotfiles Bootstrap Installer"

    echo "This script will set up your development environment with:"
    echo "  • Zsh with Oh-My-Zsh and Powerlevel10k theme"
    echo "  • Git configuration"
    echo "  • Vim with plugins"
    echo "  • Tmux configuration"
    echo "  • Development tools (optional)"
    echo ""

    # Check if non-interactive mode
    if [[ -n "${DOTFILES_NONINTERACTIVE}" ]]; then
        log_info "Running in non-interactive mode"
    else
        read -p "Continue with installation? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled."
            exit 0
        fi
    fi

    DOTFILES_DIR="${HOME}/.dotfiles"

    # Check if dotfiles already exist
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_warning "Dotfiles directory already exists at $DOTFILES_DIR"

        if [[ -z "${DOTFILES_NONINTERACTIVE}" ]]; then
            read -p "Do you want to update it? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Updating dotfiles repository..."
                cd "$DOTFILES_DIR"
                git pull origin main || log_warning "Failed to update repository"
            fi
        fi
    else
        # Clone the repository
        log_info "Cloning dotfiles repository..."

        if ! command -v git &> /dev/null; then
            log_error "Git is not installed. Please install git first."
            exit 1
        fi

        if ! git clone https://github.com/yezooz/dotfiles.git "$DOTFILES_DIR"; then
            log_error "Failed to clone repository"
            exit 1
        fi

        log_success "Repository cloned successfully"
    fi

    cd "$DOTFILES_DIR"

    # Run preflight checks
    log_header "Running Preflight Checks"
    if [[ -f "$DOTFILES_DIR/init/preflight.sh" ]]; then
        /bin/bash "$DOTFILES_DIR/init/preflight.sh"
    else
        log_warning "Preflight check script not found, skipping..."
    fi

    # Run interactive wizard if not in non-interactive mode
    if [[ -z "${DOTFILES_NONINTERACTIVE}" ]]; then
        log_header "Configuration Wizard"
        if [[ -f "$DOTFILES_DIR/init/wizard.sh" ]]; then
            /bin/bash "$DOTFILES_DIR/init/wizard.sh"
        else
            log_warning "Wizard script not found, skipping interactive setup..."
        fi
    fi

    # Run main installation
    log_header "Starting Installation"
    /bin/bash "$DOTFILES_DIR/init/init.sh"

    # Run verification
    log_header "Verifying Installation"
    if [[ -f "$DOTFILES_DIR/init/verify.sh" ]]; then
        /bin/bash "$DOTFILES_DIR/init/verify.sh"
    else
        log_warning "Verification script not found, skipping verification..."
    fi

    # Success message
    log_header "Installation Complete!"
    echo ""
    log_success "Your dotfiles have been installed successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Optional: Install additional packages with: /bin/bash ~/.dotfiles/brew.sh"
    echo "  3. Optional: Install dev tools with: /bin/bash ~/.dotfiles/init/dev_tools.sh"
    echo "  4. Optional: Install desktop apps with: /bin/bash ~/.dotfiles/init/desktop_tools.sh"
    echo ""

    if [[ -f "$HOME/.dotfiles/.install-config" ]]; then
        echo "Your configuration has been saved to: ~/.dotfiles/.install-config"
        echo ""
    fi
}

main "$@"
