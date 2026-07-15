#!/usr/bin/env bash

################################################################################
# Desktop Applications Installation
################################################################################
# Installs GUI applications, browsers, productivity tools, and media apps
################################################################################

set -e

# Source the dotfiles script for helper functions
DOTFILES_DIR="${HOME}/.dotfiles"
source "${DOTFILES_DIR}/bin/dotfiles" "source"

# Ensure Homebrew is in PATH
if is_macos && [[ -z "$(type -P brew)" ]]; then
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

if is_macos; then
    e_header "Installing Desktop Applications (macOS)"

    # ========================================
    # BROWSERS
    # ========================================
    e_arrow "Web Browsers"
    brew install --cask google-chrome
    brew install --cask brave-browser   # Privacy-focused browser
    brew install --cask tor-browser

    # ========================================
    # PRODUCTIVITY & UTILITIES
    # ========================================
    e_arrow "Productivity Tools"
    brew install --cask alfred          # Application launcher
    brew install --cask 1password       # Password manager
    brew install --cask karabiner-elements  # Keyboard customization
    brew install --cask hammerspoon     # macOS automation (window show/hide hotkeys)
    brew install --cask anki            # Flashcard learning app
    brew install --cask dictionaries    # Dictionary app
    # Kindle is installed via Mac App Store (see MAC APP STORE APPS section below)

    # ========================================
    # COMMUNICATION
    # ========================================
    e_arrow "Communication Apps"
    brew install --cask slack
    brew install --cask signal          # Private messaging

    # ========================================
    # MEDIA & ENTERTAINMENT
    # ========================================
    e_arrow "Media Applications"
    brew install --cask vlc             # Media player
    brew install --cask spotify         # Music streaming
    brew install --cask pocket-casts    # Podcast player
    brew install --cask transmission    # BitTorrent client

    # ========================================
    # UTILITIES
    # ========================================
    e_arrow "System Utilities"
    brew install --cask balenaetcher    # USB/SD card flasher
    brew install --cask focusrite-control-2  # Focusrite audio interface control

    e_arrow "Command-line Media Tools"
    brew install yt-dlp                 # YouTube downloader
    brew install mas                    # Mac App Store CLI

    e_success "Desktop applications installation complete!"

    echo ""
    e_arrow "Note: The following apps are not available via Homebrew:"
    echo ""
    echo "Mac App Store apps (if 'mas install' failed above):"
    echo "  Open the Mac App Store and search for these apps, or use these direct links:"
    echo "  • Kindle, Color Picker, WhatsApp, SnippetsLab, Moom, NextDNS,"
    echo "  • rcmd, Unarchiver, MeetingBar, Boop, Tomito, Gestimer, Things"
    echo ""
    echo "Other apps to install manually:"
    echo "  • iTerm.app - https://iterm2.com/"
    echo "  • Visual Studio Code.app - https://code.visualstudio.com/"
    echo "  • Wispr Flow.app - https://wispr.ai/"
    echo "  • Flow.app (Task manager) - Install manually"

elif is_ubuntu; then
    e_header "Installing Desktop Applications (Ubuntu)"

    # ========================================
    # BROWSERS
    # ========================================
    e_arrow "Web Browsers"
    sudo snap install chromium

    # ========================================
    # DEVELOPMENT TOOLS
    # ========================================
    e_arrow "Development Tools"
    sudo snap install postman
    sudo snap install sublime-text --classic
    sudo snap install code --classic

    # ========================================
    # COMMUNICATION
    # ========================================
    e_arrow "Communication Apps"
    sudo snap install slack --classic
    sudo snap install whatsdesk         # WhatsApp desktop

    # ========================================
    # MEDIA & FILE TRANSFER
    # ========================================
    e_arrow "Media & Utilities"
    sudo snap install vlc
    sudo snap install spotify

    e_success "Desktop applications installation complete!"
fi
