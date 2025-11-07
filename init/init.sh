#!/usr/bin/env bash

################################################################################
# Main Installation Script
################################################################################
# Orchestrates the installation process based on detected OS
# Uses configuration from .install-config if available
################################################################################

set -e

# Load dotfiles functions and environment
source ~/.dotfiles/bin/dotfiles "source"

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
export CONFIGURE_DOCK
export INSTALL_BREW_PACKAGES
export INSTALL_DEV_TOOLS
export INSTALL_DESKTOP_APPS
export INSTALL_NPM_PACKAGES
export INSTALL_UV_TOOLS

################################################################################
# PLATFORM-SPECIFIC BASE INSTALLATION
################################################################################

e_header "Starting dotfiles installation..."

# Detect OS and run platform-specific installation
if is_macos; then
    e_header "Detected: macOS"
    /bin/bash "${DOTFILES}/init/macos.sh"
elif is_ubuntu; then
    e_header "Detected: Ubuntu Linux"
    /bin/bash "${DOTFILES}/init/ubuntu.sh"
else
    e_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

e_success "Base installation complete!"

################################################################################
# OPTIONAL COMPONENTS (based on configuration)
################################################################################

e_header "Installing optional components..."

# Additional Homebrew packages (GNU utilities, modern CLI tools)
if [[ "$INSTALL_BREW_PACKAGES" == "yes" ]]; then
    e_header "Installing additional Homebrew packages"
    if /bin/bash "${DOTFILES}/brew.sh"; then
        e_success "Homebrew packages installed"
    else
        e_error "Homebrew packages installation failed (non-fatal, continuing...)"
    fi
fi

# Development tools (languages, cloud, databases)
if [[ "$INSTALL_DEV_TOOLS" == "yes" ]]; then
    e_header "Installing development tools"
    if /bin/bash "${DOTFILES}/init/dev_tools.sh"; then
        e_success "Development tools installed"
    else
        e_error "Development tools installation failed (non-fatal, continuing...)"
    fi
fi

# Desktop applications (browsers, productivity, media)
if [[ "$INSTALL_DESKTOP_APPS" == "yes" ]]; then
    e_header "Installing desktop applications"
    if /bin/bash "${DOTFILES}/init/desktop_tools.sh"; then
        e_success "Desktop applications installed"
    else
        e_error "Desktop applications installation failed (non-fatal, continuing...)"
    fi
fi

# NPM global packages
if [[ "$INSTALL_NPM_PACKAGES" == "yes" ]]; then
    e_header "Installing NPM global packages"
    if /bin/bash "${DOTFILES}/init/npm_packages.sh"; then
        e_success "NPM global packages installed"
    else
        e_error "NPM packages installation failed (non-fatal, continuing...)"
    fi
fi

# UV Python tools
if [[ "$INSTALL_UV_TOOLS" == "yes" ]]; then
    e_header "Installing UV Python tools"
    if /bin/bash "${DOTFILES}/init/uv_tools.sh"; then
        e_success "UV Python tools installed"
    else
        e_error "UV tools installation failed (non-fatal, continuing...)"
    fi
fi

# Custom fonts
if [[ "$INSTALL_FONTS" == "yes" ]]; then
    e_header "Installing custom fonts"
    if /bin/bash "${DOTFILES}/init/fonts.sh"; then
        e_success "Custom fonts installed"
    else
        e_error "Font installation failed (non-fatal, continuing...)"
    fi
fi

# SSH key generation
if [[ "$GENERATE_SSH" == "yes" ]]; then
    e_header "Generating SSH key"
    if [[ -n "$USER_EMAIL" ]]; then
        if /bin/bash "${DOTFILES}/ssh.sh" "$USER_EMAIL"; then
            e_success "SSH key generated"
        else
            e_error "SSH key generation failed (non-fatal, continuing...)"
        fi
    else
        e_error "Cannot generate SSH key: USER_EMAIL not set"
    fi
fi

# macOS-specific configurations
if is_macos; then
    # macOS system defaults
    if [[ "$APPLY_MACOS_DEFAULTS" == "yes" ]]; then
        e_header "Applying macOS system defaults"
        if /bin/bash "${DOTFILES}/mac/macos_defaults.sh"; then
            e_success "macOS defaults applied"
        else
            e_error "macOS defaults failed (non-fatal, continuing...)"
        fi
    fi

    # Dock configuration
    if [[ "$CONFIGURE_DOCK" == "yes" ]]; then
        e_header "Configuring macOS Dock"
        if /bin/bash "${DOTFILES}/mac/dock_config.sh"; then
            e_success "Dock configuration complete"
        else
            e_error "Dock configuration failed (non-fatal, continuing...)"
        fi
    fi
fi

################################################################################
# INSTALLATION COMPLETE
################################################################################

e_success "✓ Dotfiles installation complete!"
echo ""
e_arrow "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Review your configuration in: ${CONFIG_FILE}"
echo ""
