#!/usr/bin/env bash

################################################################################
# macOS Dock Configuration
################################################################################
# Configures Dock appearance, behavior, and installed applications
# Requires: dockutil (brew install dockutil)
################################################################################

set -e

# Source the dotfiles script for helper functions
DOTFILES_DIR="${HOME}/.dotfiles"
if [[ -f "${DOTFILES_DIR}/bin/dotfiles" ]]; then
    source "${DOTFILES_DIR}/bin/dotfiles"
fi

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is only for macOS"
    exit 1
fi

# Check if dockutil is installed
if ! command -v dockutil &> /dev/null; then
    echo "Error: dockutil is not installed"
    echo "Install it with: brew install dockutil"
    exit 1
fi

echo "Configuring macOS Dock..."

################################################################################
# DOCK APPEARANCE & BEHAVIOR
################################################################################

echo "→ Setting Dock appearance..."

# Dock position: 'left', 'bottom', 'right'
defaults write com.apple.dock orientation -string 'left'

# Dock icon size (pixels)
defaults write com.apple.dock tilesize -int 49

# Icon size of magnified Dock items
defaults write com.apple.dock largesize -int 64

# Enable magnification
defaults write com.apple.dock magnification -bool true

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Minimize effect: 'genie', 'scale', 'suck'
defaults write com.apple.dock mineffect -string 'scale'

# Show indicator lights for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Auto-hide delay (in seconds, 0 for instant)
defaults write com.apple.dock autohide-delay -float 0.0

# Auto-hide animation time
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

################################################################################
# DOCK APPLICATIONS
################################################################################

echo "→ Configuring Dock applications..."

# Remove all apps from Dock (optional - uncomment to start fresh)
# dockutil --remove all --no-restart

# Function to add app to Dock if it exists
add_to_dock() {
    local app_name="$1"
    local app_path="/Applications/${app_name}.app"

    if [[ -d "$app_path" ]]; then
        # Check if app is already in Dock
        if ! dockutil --find "$app_name" &> /dev/null; then
            echo "  Adding: $app_name"
            dockutil --add "$app_path" --no-restart
        else
            echo "  Already in Dock: $app_name"
        fi
    else
        echo "  Not found: $app_name (skipping)"
    fi
}

# Remove all existing apps first (optional)
echo "→ To start fresh, uncomment the line in the script to remove all apps"

# Add applications in desired order
# Customize this list based on your preferences

echo "→ Adding productivity apps..."
add_to_dock "Claude"
add_to_dock "Things3"
add_to_dock "Calendar"
add_to_dock "Mail"

echo "→ Adding development tools..."
add_to_dock "iTerm"
add_to_dock "Visual Studio Code"
add_to_dock "Sublime Text"
add_to_dock "PyCharm"
add_to_dock "WebStorm"
add_to_dock "GoLand"
add_to_dock "DataGrip"

echo "→ Adding browsers..."
add_to_dock "Brave Browser"
add_to_dock "Google Chrome"

echo "→ Adding communication apps..."
add_to_dock "Slack"
add_to_dock "Signal"

echo "→ Adding creative tools..."
add_to_dock "Typora"

echo "→ Adding utilities..."
add_to_dock "System Settings"

# Add folders to Dock (optional)
# Downloads folder
# dockutil --add '~/Downloads' --view grid --display folder --sort dateadded --no-restart

################################################################################
# RESTART DOCK
################################################################################

echo "→ Restarting Dock..."
killall Dock

echo "✓ Dock configuration complete!"
echo ""
echo "Current Dock settings:"
echo "  Position: $(defaults read com.apple.dock orientation)"
echo "  Size: $(defaults read com.apple.dock tilesize)"
echo "  Auto-hide: $(defaults read com.apple.dock autohide)"
echo ""
echo "To customize:"
echo "  1. Edit this script: $0"
echo "  2. Modify the 'add_to_dock' calls to add/remove apps"
echo "  3. Run the script again to apply changes"
