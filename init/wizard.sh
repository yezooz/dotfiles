#!/usr/bin/env bash

################################################################################
# Interactive Setup Wizard
################################################################################
# Collects user preferences before installation
# Saves configuration to ~/.dotfiles/.install-config
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

DOTFILES="${HOME}/.dotfiles"
CONFIG_FILE="${DOTFILES}/.install-config"

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_question() {
    echo -e "${CYAN}?${NC} ${BOLD}$1${NC}"
}

log_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Configuration variables
USER_EMAIL=""
USER_NAME=""
INSTALL_PROFILE="minimal"
GENERATE_SSH="no"
APPLY_MACOS_DEFAULTS="no"
INSTALL_BREW_PACKAGES="no"
INSTALL_DEV_TOOLS="no"
INSTALL_DESKTOP_APPS="no"
INSTALL_NPM_PACKAGES="no"
INSTALL_UV_TOOLS="no"

# Check if configuration already exists
load_existing_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        log_info "Found existing configuration"
        source "$CONFIG_FILE"
        return 0
    fi
    return 1
}

# Prompt for user email
prompt_email() {
    log_question "What's your email address?"
    echo -n "  (for git commits): "
    read -r input

    if [[ -n "$input" ]]; then
        USER_EMAIL="$input"
    elif [[ -z "$USER_EMAIL" ]]; then
        USER_EMAIL="user@example.com"
        log_info "Using default: $USER_EMAIL"
    fi
}

# Prompt for user name
prompt_name() {
    log_question "What's your full name?"
    echo -n "  (for git commits): "
    read -r input

    if [[ -n "$input" ]]; then
        USER_NAME="$input"
    elif [[ -z "$USER_NAME" ]]; then
        USER_NAME="Your Name"
        log_info "Using default: $USER_NAME"
    fi
}

# Prompt for installation profile
prompt_profile() {
    log_question "Choose installation profile:"
    echo ""
    echo "  1) Minimal      - Shell + Git + Vim + Tmux (recommended for servers)"
    echo "  2) Developer    - Minimal + Dev tools + Docker + K8s"
    echo "  3) Full         - Developer + Desktop applications"
    echo ""
    echo -n "  Enter choice [1-3] (default: 1): "
    read -r input

    case "$input" in
        1|"")
            INSTALL_PROFILE="minimal"
            ;;
        2)
            INSTALL_PROFILE="developer"
            INSTALL_DEV_TOOLS="yes"
            ;;
        3)
            INSTALL_PROFILE="full"
            INSTALL_DEV_TOOLS="yes"
            INSTALL_DESKTOP_APPS="yes"
            ;;
        *)
            log_info "Invalid choice, using minimal profile"
            INSTALL_PROFILE="minimal"
            ;;
    esac

    log_success "Profile: $INSTALL_PROFILE"
}

# Prompt for additional Homebrew packages
prompt_brew_packages() {
    log_question "Install additional Homebrew packages?"
    echo "  (GNU utilities, modern CLI tools, etc.)"
    echo -n "  [y/N]: "
    read -r -n 1 input
    echo ""

    if [[ "$input" =~ ^[Yy]$ ]]; then
        INSTALL_BREW_PACKAGES="yes"
        log_success "Will install additional Homebrew packages"
    else
        INSTALL_BREW_PACKAGES="no"
    fi
}

# Prompt for SSH key generation
prompt_ssh() {
    log_question "Generate SSH key (Ed25519)?"
    echo -n "  [y/N]: "
    read -r -n 1 input
    echo ""

    if [[ "$input" =~ ^[Yy]$ ]]; then
        GENERATE_SSH="yes"
        log_success "Will generate SSH key"
    else
        GENERATE_SSH="no"
    fi
}

# Prompt for macOS defaults (macOS only)
prompt_macos_defaults() {
    if [[ "$OSTYPE" =~ ^darwin ]]; then
        log_question "Apply macOS system defaults?"
        echo "  (Sensible macOS preferences for development)"
        echo -n "  [y/N]: "
        read -r -n 1 input
        echo ""

        if [[ "$input" =~ ^[Yy]$ ]]; then
            APPLY_MACOS_DEFAULTS="yes"
            log_success "Will apply macOS defaults"
        else
            APPLY_MACOS_DEFAULTS="no"
        fi
    fi
}

# Save configuration
save_config() {
    log_info "Saving configuration..."

    cat > "$CONFIG_FILE" << EOF
# Dotfiles Installation Configuration
# Generated on $(date)

# User Information
USER_EMAIL="$USER_EMAIL"
USER_NAME="$USER_NAME"

# Installation Profile
INSTALL_PROFILE="$INSTALL_PROFILE"

# Optional Components
GENERATE_SSH="$GENERATE_SSH"
APPLY_MACOS_DEFAULTS="$APPLY_MACOS_DEFAULTS"
INSTALL_BREW_PACKAGES="$INSTALL_BREW_PACKAGES"
INSTALL_DEV_TOOLS="$INSTALL_DEV_TOOLS"
INSTALL_DESKTOP_APPS="$INSTALL_DESKTOP_APPS"
INSTALL_NPM_PACKAGES="$INSTALL_NPM_PACKAGES"
INSTALL_UV_TOOLS="$INSTALL_UV_TOOLS"
EOF

    log_success "Configuration saved to: $CONFIG_FILE"
}

# Display configuration summary
display_summary() {
    log_header "Configuration Summary"

    echo "User Information:"
    echo "  Name:  $USER_NAME"
    echo "  Email: $USER_EMAIL"
    echo ""
    echo "Installation Profile: $INSTALL_PROFILE"
    echo ""
    echo "Optional Components:"
    echo "  • Homebrew packages: $INSTALL_BREW_PACKAGES"
    echo "  • Development tools: $INSTALL_DEV_TOOLS"
    echo "  • Desktop apps:      $INSTALL_DESKTOP_APPS"
    echo "  • NPM packages:      $INSTALL_NPM_PACKAGES"
    echo "  • UV Python tools:   $INSTALL_UV_TOOLS"
    echo "  • SSH key:           $GENERATE_SSH"
    [[ "$OSTYPE" =~ ^darwin ]] && echo "  • macOS defaults:    $APPLY_MACOS_DEFAULTS"
    echo ""
}

# Main wizard
main() {
    log_header "Dotfiles Setup Wizard"

    echo "This wizard will help you customize your installation."
    echo ""

    # Check for existing config
    if load_existing_config; then
        log_question "Use existing configuration?"
        echo -n "  [Y/n]: "
        read -r -n 1 input
        echo ""

        if [[ ! "$input" =~ ^[Nn]$ ]]; then
            log_success "Using existing configuration"
            display_summary
            return 0
        fi
    fi

    # Collect user preferences
    echo "Press Enter to accept defaults shown in parentheses."
    echo ""

    prompt_email
    prompt_name
    echo ""

    prompt_profile
    echo ""

    # Additional options based on profile
    if [[ "$INSTALL_PROFILE" == "minimal" ]]; then
        prompt_brew_packages
        log_question "Install development tools?"
        echo "  (Languages, Docker, Kubernetes, etc.)"
        echo -n "  [y/N]: "
        read -r -n 1 input
        echo ""
        if [[ "$input" =~ ^[Yy]$ ]]; then
            INSTALL_DEV_TOOLS="yes"
        fi
        echo ""
    fi

    # Check if desktop environment exists (for Linux)
    if [[ "$OSTYPE" =~ ^linux ]] && [[ "$INSTALL_PROFILE" != "full" ]]; then
        if dpkg -l ubuntu-desktop >/dev/null 2>&1 || [[ -n "$DISPLAY" ]]; then
            log_question "Install desktop applications?"
            echo "  (Browsers, editors, communication tools)"
            echo -n "  [y/N]: "
            read -r -n 1 input
            echo ""
            if [[ "$input" =~ ^[Yy]$ ]]; then
                INSTALL_DESKTOP_APPS="yes"
            fi
            echo ""
        fi
    fi

    prompt_ssh
    echo ""

    # Prompt for NPM packages
    if command -v npm &> /dev/null || [[ "$INSTALL_DEV_TOOLS" == "yes" ]]; then
        log_question "Install NPM global packages?"
        echo "  (@openai/codex, @playwright/mcp, yarn)"
        echo -n "  [y/N]: "
        read -r -n 1 input
        echo ""
        if [[ "$input" =~ ^[Yy]$ ]]; then
            INSTALL_NPM_PACKAGES="yes"
            log_success "Will install NPM global packages"
        else
            INSTALL_NPM_PACKAGES="no"
        fi
        echo ""
    fi

    # Prompt for UV Python tools
    log_question "Install UV Python tools?"
    echo "  (llm, poetry, pre-commit, scrapy, git-filter-repo)"
    echo -n "  [y/N]: "
    read -r -n 1 input
    echo ""
    if [[ "$input" =~ ^[Yy]$ ]]; then
        INSTALL_UV_TOOLS="yes"
        log_success "Will install UV Python tools"
    else
        INSTALL_UV_TOOLS="no"
    fi
    echo ""

    prompt_macos_defaults
    echo ""

    # Save and display configuration
    save_config
    display_summary

    log_question "Proceed with installation?"
    echo -n "  [Y/n]: "
    read -r -n 1 input
    echo ""

    if [[ "$input" =~ ^[Nn]$ ]]; then
        log_info "Installation cancelled. Run this wizard again to reconfigure."
        exit 1
    fi

    log_success "Configuration complete! Proceeding with installation..."
}

main "$@"
