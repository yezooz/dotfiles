#!/usr/bin/env bash

################################################################################
# Desktop Applications Installation
################################################################################
# Installs GUI applications, browsers, productivity tools, and media apps
################################################################################

set -e

# Source the dotfiles script for helper functions
DOTFILES_DIR="${HOME}/.dotfiles"
source "${DOTFILES_DIR}/bin/dotfiles"

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
    brew install --cask anki            # Flashcard learning app
    brew install --cask dictionaries    # Dictionary app
    brew install --cask kindle          # eBook reader

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

    # ========================================
    # MAC APP STORE APPS
    # ========================================
    e_arrow "Installing Mac App Store Apps"
    mas install 1545870783 # Color Picker
    mas install 1147396723 # WhatsApp
    mas install 1006087419 # SnippetsLab (code snippets)
    mas install 419330170  # Moom (window manager)
    mas install 1464122853 # NextDNS
    mas install 1596283165 # rcmd (app switcher)
    mas install 425424353  # Unarchiver
    mas install 1532419400 # MeetingBar (calendar in menu bar)
    mas install 1518425043 # Boop (text transformer)
    mas install 1526042938 # Tomito (Pomodoro timer)
    mas install 990588172  # Gestimer (simple timer)
    mas install 904280696  # Things (task manager)

    e_success "Desktop applications installation complete!"

    echo ""
    e_arrow "Note: The following apps are not available via Homebrew and must be installed manually:"
    echo "  • iTerm.app - https://iterm2.com/"
    echo "  • Visual Studio Code.app - https://code.visualstudio.com/"
    echo "  • Docker.app - https://www.docker.com/products/docker-desktop"
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
