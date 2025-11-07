#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Don't exit on error - continue installing other packages even if one fails
set +e

echo "=================================================="
echo "Starting Homebrew packages installation"
echo "This may take 10-15 minutes..."
echo "=================================================="

# Ensure Homebrew is in PATH
if [[ -z "$(type -P brew)" ]]; then
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        # Apple Silicon
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo "Error: Homebrew not found. Please install Homebrew first."
        exit 1
    fi
fi

# Make sure we're using the latest Homebrew.
echo "[1/8] Updating Homebrew..."
brew update

# Upgrade any already-installed formulae (commented out - can take very long).
# Run manually if needed: brew upgrade
# brew upgrade

# Save Homebrew's installed location.
BREW_PREFIX=$(brew --prefix)

echo "[2/8] Installing GNU core utilities..."
# Install GNU core utilities (those that come with macOS are outdated).
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Create sha256sum symlink only if gsha256sum exists and symlink doesn't already exist
if [[ -f "${BREW_PREFIX}/bin/gsha256sum" ]] && [[ ! -e "${BREW_PREFIX}/bin/sha256sum" ]]; then
  ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! grep -F -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php@8.1
brew install gmp

echo "[3/8] Installing font tools..."
# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

echo "[4/8] Installing useful binaries..."
# Install other useful binaries.
brew install ack
#brew install exiv2
brew install git
brew install git-lfs
brew install gs
brew install imagemagick
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install mas
brew install qlcolorcode qlstephen qlmarkdown quicklook-json suspicious-package apparency quicklookase qlvideo

echo "[5/8] Installing modern CLI tools..."
# Install modern CLI tools
brew install tmux           # Terminal multiplexer
brew install fzf            # Fuzzy finder
brew install bat            # Better cat with syntax highlighting
brew install ripgrep        # Fast grep alternative
brew install fd             # Better find alternative
brew install delta          # Better git diff viewer
brew install btop           # Interactive process viewer

echo "[6/8] Installing eza and jq..."
# Install eza (modern ls replacement) if not already installed
brew install eza

# Install jq (JSON processor) if not already installed
brew install jq

echo "[7/8] Installing macOS utilities..."
# Install macOS utilities
brew install dockutil        # Dock management tool

brew install --cask 1password/tap/1password-cli

echo "[8/8] Cleaning up..."
# Remove outdated versions from the cellar.
brew cleanup

echo "=================================================="
echo "Homebrew packages installation complete!"
echo "=================================================="