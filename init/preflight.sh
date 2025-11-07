#!/usr/bin/env bash

################################################################################
# Preflight Checks - System Requirements Validation
################################################################################
# This script checks if the system meets all requirements before installation
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_check() {
    printf "${BLUE}➜${NC} Checking $1... "
}

log_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

log_fail() {
    echo -e "${RED}✖${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# OS Detection
detect_os() {
    if [[ "$OSTYPE" =~ ^darwin ]]; then
        echo "macos"
    elif [[ "$OSTYPE" =~ ^linux ]]; then
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            echo "$ID"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

# Check functions
check_os() {
    log_check "operating system"
    OS=$(detect_os)

    case "$OS" in
        macos)
            OS_VERSION=$(sw_vers -productVersion)
            log_pass "macOS $OS_VERSION"
            return 0
            ;;
        ubuntu|debian)
            OS_VERSION=$(lsb_release -rs 2>/dev/null || echo "unknown")
            log_pass "Ubuntu/Debian $OS_VERSION"
            return 0
            ;;
        *)
            log_warning "Unknown OS: $OSTYPE (installation may not work correctly)"
            return 1
            ;;
    esac
}

check_internet() {
    log_check "internet connection"
    if ping -c 1 -W 2 github.com &> /dev/null; then
        log_pass "Connected"
        return 0
    else
        log_fail "No internet connection"
        log_info "Internet connection required for installation"
        return 1
    fi
}

check_disk_space() {
    log_check "disk space"

    if command -v df &> /dev/null; then
        AVAILABLE=$(df -h "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')

        if command -v bc &> /dev/null; then
            if (( $(echo "$AVAILABLE > 2" | bc -l) )); then
                log_pass "${AVAILABLE}GB available"
                return 0
            else
                log_warning "${AVAILABLE}GB available (recommend at least 2GB)"
                return 1
            fi
        else
            log_pass "Available"
            return 0
        fi
    else
        log_warning "Unable to check disk space"
        return 1
    fi
}

check_git() {
    log_check "git"

    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version | awk '{print $3}')
        log_pass "Installed (v$GIT_VERSION)"
        return 0
    else
        log_fail "Not installed"
        return 1
    fi
}

check_curl() {
    log_check "curl"

    if command -v curl &> /dev/null; then
        log_pass "Installed"
        return 0
    else
        log_fail "Not installed"
        return 1
    fi
}

check_xcode_macos() {
    log_check "Xcode Command Line Tools"

    if xcode-select -p &> /dev/null; then
        log_pass "Installed"
        return 0
    else
        log_fail "Not installed"
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        log_warning "Please wait for Xcode tools to install, then re-run this script"
        return 1
    fi
}

check_sudo() {
    log_check "sudo privileges"

    if sudo -n true 2>/dev/null; then
        log_pass "Available"
        return 0
    else
        # Test if sudo works with password
        if sudo -v &> /dev/null; then
            log_pass "Available (password required)"
            return 0
        else
            log_fail "Not available"
            return 1
        fi
    fi
}

check_homebrew() {
    log_check "Homebrew"

    if command -v brew &> /dev/null; then
        BREW_VERSION=$(brew --version | head -n1 | awk '{print $2}')
        log_pass "Installed (v$BREW_VERSION)"
        return 0
    else
        log_info "Not installed (will be installed during setup)"
        return 0
    fi
}

check_shell() {
    log_check "current shell"

    CURRENT_SHELL=$(basename "$SHELL")
    log_pass "$CURRENT_SHELL"

    if [[ "$CURRENT_SHELL" != "zsh" ]]; then
        log_info "Shell will be changed to Zsh during installation"
    fi

    return 0
}

# Main preflight check
main() {
    echo "Running preflight checks..."
    echo ""

    ERRORS=0
    WARNINGS=0

    OS=$(detect_os)

    # Common checks
    check_os || ((ERRORS++))
    check_internet || ((ERRORS++))
    check_disk_space || ((WARNINGS++))
    check_git || ((ERRORS++))
    check_curl || ((ERRORS++))
    check_shell

    # OS-specific checks
    if [[ "$OS" == "macos" ]]; then
        check_xcode_macos || ((ERRORS++))
        check_homebrew
    elif [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
        check_sudo || ((ERRORS++))
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [[ $ERRORS -gt 0 ]]; then
        echo -e "${RED}✖ Preflight checks failed with $ERRORS error(s)${NC}"

        if [[ "$OS" == "macos" ]]; then
            echo ""
            echo "To install missing requirements on macOS:"
            echo "  - Xcode Tools: xcode-select --install"
        elif [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
            echo ""
            echo "To install missing requirements on Ubuntu/Debian:"
            echo "  sudo apt-get update"
            echo "  sudo apt-get install -y git curl"
        fi

        exit 1
    elif [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠ Preflight checks passed with $WARNINGS warning(s)${NC}"
        echo -e "${GREEN}✓ You can proceed with installation${NC}"
        exit 0
    else
        echo -e "${GREEN}✓ All preflight checks passed!${NC}"
        exit 0
    fi
}

main "$@"
