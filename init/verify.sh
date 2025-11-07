#!/usr/bin/env bash

################################################################################
# Post-Installation Verification Script
################################################################################
# Verifies that all components were installed correctly
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES="${HOME}/.dotfiles"
CONFIG_FILE="${DOTFILES}/.install-config"

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Logging functions
log_check() {
    printf "${BLUE}➜${NC} Checking $1... "
}

log_pass() {
    echo -e "${GREEN}✓${NC}"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}✖${NC}"
    echo -e "  ${RED}Error:${NC} $1"
    ((FAILED++))
}

log_warning() {
    echo -e "${YELLOW}⚠${NC}"
    echo -e "  ${YELLOW}Warning:${NC} $1"
    ((WARNINGS++))
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Load config if exists
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

# Check symlinks
check_symlinks() {
    log_header "Verifying Symlinks"

    # Zsh files
    log_check "~/.zshrc symlink"
    if [[ -L "$HOME/.zshrc" ]] && [[ -f "$HOME/.zshrc" ]]; then
        TARGET=$(readlink "$HOME/.zshrc")
        if [[ "$TARGET" == *"dotfiles"* ]]; then
            log_pass
        else
            log_fail "Symlink points to wrong location: $TARGET"
        fi
    else
        log_fail "Not a valid symlink"
    fi

    log_check "~/.p10k.zsh symlink"
    if [[ -L "$HOME/.p10k.zsh" ]] && [[ -f "$HOME/.p10k.zsh" ]]; then
        log_pass
    else
        log_warning "Powerlevel10k config not symlinked"
    fi

    # Git files
    log_check "~/.gitconfig symlink"
    if [[ -L "$HOME/.gitconfig" ]] && [[ -f "$HOME/.gitconfig" ]]; then
        log_pass
    else
        log_fail "Not a valid symlink"
    fi

    log_check "~/.gitignore symlink"
    if [[ -L "$HOME/.gitignore" ]] && [[ -f "$HOME/.gitignore" ]]; then
        log_pass
    else
        log_fail "Not a valid symlink"
    fi

    # Neovim config
    log_check "~/.config/nvim directory"
    if [[ -d "$HOME/.config/nvim" ]]; then
        log_pass
    else
        log_warning "Neovim config not found (may not be installed)"
    fi

    # Tmux files
    log_check "~/.tmux.conf symlink"
    if [[ -L "$HOME/.tmux.conf" ]] && [[ -f "$HOME/.tmux.conf" ]]; then
        log_pass
    else
        log_warning "Tmux config not symlinked (may not be installed)"
    fi
}

# Check required binaries
check_binaries() {
    log_header "Verifying Required Binaries"

    log_check "zsh"
    if command -v zsh &> /dev/null; then
        VERSION=$(zsh --version | awk '{print $2}')
        echo -e "${GREEN}✓${NC} (v$VERSION)"
        ((PASSED++))
    else
        log_fail "Not installed"
    fi

    log_check "git"
    if command -v git &> /dev/null; then
        VERSION=$(git --version | awk '{print $3}')
        echo -e "${GREEN}✓${NC} (v$VERSION)"
        ((PASSED++))
    else
        log_fail "Not installed"
    fi

    log_check "brew"
    if command -v brew &> /dev/null; then
        VERSION=$(brew --version | head -n1 | awk '{print $2}')
        echo -e "${GREEN}✓${NC} (v$VERSION)"
        ((PASSED++))
    else
        log_fail "Not installed"
    fi

    log_check "exa"
    if command -v exa &> /dev/null; then
        log_pass
    else
        log_warning "Not installed (ls alias may not work)"
    fi

    log_check "nvim"
    if command -v nvim &> /dev/null; then
        VERSION=$(nvim --version | head -n1 | awk '{print $2}')
        echo -e "${GREEN}✓${NC} (v$VERSION)"
        ((PASSED++))
    else
        log_warning "Not installed"
    fi

    log_check "tmux"
    if command -v tmux &> /dev/null; then
        log_pass
    else
        log_warning "Not installed"
    fi
}

# Check Oh-My-Zsh installation
check_oh_my_zsh() {
    log_header "Verifying Oh-My-Zsh"

    log_check "Oh-My-Zsh directory"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_pass
    else
        log_fail "Directory not found"
        return
    fi

    log_check "Powerlevel10k theme"
    if [[ -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        log_pass
    else
        log_fail "Theme not installed"
    fi

    log_check "zsh-autosuggestions plugin"
    if [[ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        log_pass
    else
        log_fail "Plugin not installed"
    fi

    log_check "zsh-syntax-highlighting plugin"
    if [[ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        log_pass
    else
        log_fail "Plugin not installed"
    fi
}

# Check Git configuration
check_git_config() {
    log_header "Verifying Git Configuration"

    log_check "git user.email"
    GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    if [[ -n "$GIT_EMAIL" ]]; then
        echo -e "${GREEN}✓${NC} ($GIT_EMAIL)"
        ((PASSED++))
    else
        if [[ -n "${USER_EMAIL}" ]] && [[ "${USER_EMAIL}" != "user@example.com" ]]; then
            log_warning "Not set (should be configured from environment)"
        else
            log_warning "Not set (configure manually or via environment variable)"
        fi
    fi

    log_check "git user.name"
    GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    if [[ -n "$GIT_NAME" ]]; then
        echo -e "${GREEN}✓${NC} ($GIT_NAME)"
        ((PASSED++))
    else
        log_warning "Not set (configure manually or via environment variable)"
    fi
}

# Check shell configuration
check_shell() {
    log_header "Verifying Shell Configuration"

    log_check "current shell"
    CURRENT_SHELL=$(basename "$SHELL")
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        log_pass
    else
        log_warning "Current shell is $CURRENT_SHELL, not zsh"
        log_info "Change shell with: chsh -s \$(which zsh)"
    fi

    log_check "zsh can be started"
    if zsh -c "exit" 2>/dev/null; then
        log_pass
    else
        log_fail "Zsh fails to start"
    fi

    log_check "dotfiles in PATH"
    if [[ ":$PATH:" == *":$DOTFILES/bin:"* ]]; then
        log_pass
    else
        log_warning "Dotfiles bin directory not in PATH (restart shell)"
    fi
}

# Check optional components
check_optional() {
    log_header "Verifying Optional Components"

    # Check if dev tools were requested
    if [[ "${INSTALL_DEV_TOOLS}" == "yes" ]]; then
        log_check "kubectl"
        if command -v kubectl &> /dev/null; then
            log_pass
        else
            log_warning "Not installed"
        fi

        log_check "docker"
        if command -v docker &> /dev/null; then
            log_pass
        else
            log_warning "Not installed"
        fi
    fi

    # Check SSH key if requested
    if [[ "${GENERATE_SSH}" == "yes" ]]; then
        log_check "SSH key"
        if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
            log_pass
        else
            log_warning "Not found (may need to be generated manually)"
        fi
    fi

    # Check LazyVim
    log_check "LazyVim config"
    if [[ -d "$HOME/.config/nvim" ]] && [[ -f "$HOME/.config/nvim/init.lua" ]]; then
        log_pass
    else
        log_warning "Not installed (run installation script)"
    fi

    # Check Tmux plugins
    log_check "Tmux plugin manager"
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_pass
    else
        log_warning "Not installed"
    fi
}

# Generate summary
generate_summary() {
    log_header "Verification Summary"

    TOTAL=$((PASSED + FAILED + WARNINGS))

    echo "Results:"
    echo -e "  ${GREEN}✓${NC} Passed:   $PASSED"
    echo -e "  ${RED}✖${NC} Failed:   $FAILED"
    echo -e "  ${YELLOW}⚠${NC} Warnings: $WARNINGS"
    echo "  ─────────────────"
    echo "  Total:    $TOTAL"
    echo ""

    if [[ $FAILED -gt 0 ]]; then
        echo -e "${RED}✖ Installation verification failed${NC}"
        echo ""
        echo "Some components are missing or misconfigured."
        echo "Review the errors above and re-run the installation if needed."
        echo ""
        exit 1
    elif [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠ Installation completed with warnings${NC}"
        echo ""
        echo "Most components are installed, but some optional features may need attention."
        echo "Review the warnings above."
        echo ""
        exit 0
    else
        echo -e "${GREEN}✓ Installation verified successfully!${NC}"
        echo ""
        echo "All components are installed and configured correctly."
        echo ""
        exit 0
    fi
}

# Main verification
main() {
    echo "Running post-installation verification..."
    echo ""

    check_symlinks
    check_binaries
    check_oh_my_zsh
    check_git_config
    check_shell
    check_optional

    generate_summary
}

main "$@"
