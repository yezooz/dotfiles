# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that configures development environments for both macOS and Linux (Ubuntu) systems. The setup includes shell configuration (Zsh with Oh-My-Zsh and Powerlevel10k), terminal tools (Tmux), editor config (Vim), Git configuration, and various development tools.

## Architecture

### Entry Point

**New One-Click Installation System**:
- `bootstrap.sh` - Primary installation entry point that can be run directly from GitHub:
  ```bash
  bash <(curl -fsSL https://raw.githubusercontent.com/yezooz/dotfiles/main/bootstrap.sh)
  ```
  - Clones the repository to `~/.dotfiles` if it doesn't exist
  - Runs preflight checks to validate system requirements
  - Launches interactive wizard for user configuration
  - Executes main installation via `init/init.sh`
  - Runs post-installation verification
  - Supports `DOTFILES_NONINTERACTIVE` environment variable for automated installs

**Traditional Installation**:
- `init/init.sh` - Core installation script that:
  - Sources `bin/dotfiles` for core functions and OS detection
  - Detects the OS (macOS/Ubuntu) and runs platform-specific installation scripts
  - Loads Zsh dependencies from `zsh/deps/` directory
  - Can be run standalone or via bootstrap.sh

### Core Components

**`bin/dotfiles`** - Core utility script that provides:
- Logging functions (e_header, e_success, e_error, e_arrow)
- OS detection functions (is_macos, is_linux, is_ubuntu, is_ubuntu_desktop)
- Sources all Zsh dependency files from `zsh/deps/` in order: path.zsh, exports.zsh, aliases.zsh, functions.zsh, autocomplete.zsh, bindkeys.zsh
- Platform-specific files (macos.zsh or linux.zsh) are loaded based on OS detection

**Zsh Configuration Flow**:
1. `~/.zshrc` (symlink to `zsh/zshrc`) - Loads Oh-My-Zsh and Powerlevel10k theme
2. Sources `bin/dotfiles "source"` which loads all files from `zsh/deps/`
3. Sources `~/.p10k.zsh` (symlink to `zsh/p10k.zsh`) for Powerlevel10k configuration

**Platform-Specific Installation**:
- `init/macos.sh` - macOS setup: Homebrew, Zsh, Oh-My-Zsh plugins, symlinks config files, iTerm2 configuration
- `init/ubuntu.sh` - Ubuntu setup: System packages, Docker, Homebrew for Linux, fonts
- `init/_linux.sh` - Shared Linux utilities

**Installation Support Scripts**:
- `init/preflight.sh` - System requirements validation before installation
  - Checks OS compatibility (macOS/Ubuntu)
  - Verifies internet connection and disk space
  - Validates required dependencies (git, curl, Xcode tools on macOS)
  - Checks sudo privileges on Linux
- `init/wizard.sh` - Interactive setup wizard for collecting user preferences
  - Prompts for git user name and email
  - Offers installation profiles (minimal, developer, full)
  - Allows selection of optional components (Homebrew packages, dev tools, desktop apps)
  - Saves configuration to `.install-config` file
  - Supports reusing existing configuration
- `init/verify.sh` - Post-installation verification
  - Validates symlinks for all config files
  - Checks that required binaries are installed (zsh, git, brew, etc.)
  - Verifies Oh-My-Zsh and plugins installation
  - Confirms Git configuration (user.name, user.email)
  - Tests shell configuration and PATH setup
  - Reports installation status with pass/fail/warning counts

**Optional Installation Scripts**:
- `init/dev_tools.sh` - Development tools (languages, databases, cloud tools, containers)
- `init/desktop_tools.sh` - Desktop applications (browsers, productivity, media)
- `brew.sh` - Additional Homebrew packages (GNU utilities, modern tools)
- `mac/macos_defaults.sh` - macOS system preferences configuration
- `ssh.sh` - SSH key generation script (Ed25519 keys)

### Configuration Files

Symlinks are created from `~/.dotfiles/` to `~/`:
- `zsh/zshrc` → `~/.zshrc`
- `zsh/p10k.zsh` → `~/.p10k.zsh`
- `git/gitconfig` → `~/.gitconfig`
- `git/gitignore` → `~/.gitignore`
- `git/git_template` → `~/.git_template`
- `vimrc` → `~/.vimrc`
- `tmux.conf` → `~/.tmux.conf`
- `bashrc` → `~/.bashrc`

**iTerm2 Configuration (macOS)**:
The `iterm/` directory contains iTerm2 preferences that are automatically loaded:
- `com.googlecode.iterm2.plist` - Main iTerm2 preferences (profiles, key bindings, themes, settings)
- `dark.json` - Dark color scheme profile
- During installation, iTerm2 is configured via `defaults write` to load preferences from this directory
- All iTerm2 settings are version controlled and automatically synced

### Custom Git Commands

The `bin/` directory contains custom git helper scripts (prefix `git-*`) that become available as git subcommands, e.g., `git-current-branch` can be called as `git current-branch`.

## Common Commands

### Installation

**Recommended: One-Click Installation** (with interactive wizard):
```bash
# Run directly from GitHub - includes preflight checks, wizard, and verification
bash <(curl -fsSL https://raw.githubusercontent.com/yezooz/dotfiles/main/bootstrap.sh)

# Non-interactive mode (uses defaults)
DOTFILES_NONINTERACTIVE=1 bash <(curl -fsSL https://raw.githubusercontent.com/yezooz/dotfiles/main/bootstrap.sh)
```

**Manual Installation** (if repository already cloned):
```bash
# Full fresh installation
cd ~/.dotfiles
/bin/bash init/init.sh

# With preflight checks and verification
/bin/bash init/preflight.sh && /bin/bash init/init.sh && /bin/bash init/verify.sh

# Run interactive wizard to configure installation
/bin/bash init/wizard.sh
```

**Optional Components**:
```bash
# Install additional Homebrew packages
/bin/bash ~/.dotfiles/brew.sh

# Install development tools
/bin/bash ~/.dotfiles/init/dev_tools.sh

# Install desktop applications
/bin/bash ~/.dotfiles/init/desktop_tools.sh

# Install Vim plugins
vim +PluginInstall +qall

# Generate SSH key
/bin/bash ~/.dotfiles/ssh.sh your-email@example.com

# Verify installation
/bin/bash ~/.dotfiles/init/verify.sh
```

### Maintenance
```bash
# Update dotfiles from git
cd ~/.dotfiles && git pull origin main

# Update Homebrew packages
brew update && brew upgrade

# Update Oh-My-Zsh
omz update

# Update Vim plugins
vim +PluginUpdate +qall

# Reload shell configuration
reload  # alias for: clear && exec zsh
```

### Testing Changes
After modifying shell configuration files, test with:
```bash
source ~/.zshrc
# or
reload
```

## Important Configuration Details

### Installation Configuration

The interactive wizard (`init/wizard.sh`) saves user preferences to `.install-config` file, which includes:
- User name and email for git commits
- Installation profile (minimal/developer/full)
- Optional component selections (Homebrew packages, dev tools, desktop apps, SSH key, macOS defaults)
- This file is gitignored and can be reused for updates or reconfiguration

Installation profiles:
- **Minimal**: Shell + Git + Vim + Tmux (recommended for servers)
- **Developer**: Minimal + Development tools + Docker + Kubernetes
- **Full**: Developer + Desktop applications

### Git Configuration
- The gitconfig intentionally omits user.name and user.email from version control
- Users should set via environment variables in `zsh/deps/exports.zsh`:
  ```bash
  export USER_EMAIL="your.email@example.com"
  export GIT_AUTHOR_EMAIL="$USER_EMAIL"
  export GIT_COMMITTER_EMAIL="$USER_EMAIL"
  export GIT_AUTHOR_NAME="Your Name"
  export GIT_COMMITTER_NAME="Your Name"
  ```
- Or use local git config: `git config --global user.email "your.email@example.com"`

### Zsh Plugin Loading
The `zsh/zshrc` defines which Oh-My-Zsh plugins to load. Currently active plugins:
- colorize (uses chroma)
- zsh-syntax-highlighting
- zsh-autosuggestions
- zsh-interactive-cd
- zsh-window-title

These plugins are installed during `init/macos.sh` or `init/ubuntu.sh` setup.

### Custom Aliases
Key aliases defined in `zsh/deps/aliases.zsh`:
- Uses `eza` instead of `ls` for better directory listings (with icons)
- `k` = kubectl (if installed)
- `docker` = podman
- `reload` = restart shell session
- Various shortcuts for navigation (.., ..., ...., etc.)

### PATH Management
PATH is configured in `zsh/deps/path.zsh` and includes:
- Homebrew binaries
- Local bin directories
- Go, Ruby, Python, Node.js paths
- Custom scripts from `~/.dotfiles/bin`

### iTerm2 Configuration (macOS)

The `iterm/` directory contains version-controlled iTerm2 preferences:
- `com.googlecode.iterm2.plist` - All iTerm2 settings (profiles, themes, key bindings, preferences)
- `dark.json` - Dark color scheme profile
- `.DS_Store` - macOS metadata (gitignored)

**Automatic Setup**:
- During macOS installation (`init/macos.sh`), iTerm2 is configured to automatically load preferences from `~/.dotfiles/iterm`
- Uses `defaults write com.googlecode.iterm2 PrefsCustomFolder` and `LoadPrefsFromCustomFolder`
- Restart iTerm2 after installation to apply settings

**Managing iTerm2 Settings**:

To manually configure iTerm2 to use dotfiles:
1. Open iTerm2 → Preferences → General → Preferences
2. Check "Load preferences from a custom folder or URL"
3. Set path to: `~/.dotfiles/iterm`
4. Check "Save changes to folder when iTerm2 quits" (optional - enables auto-sync)

To backup new iTerm2 changes:
```bash
# Settings are automatically saved to ~/.dotfiles/iterm/com.googlecode.iterm2.plist
# if auto-save is enabled, otherwise export manually from Preferences

# Commit changes
cd ~/.dotfiles
git add iterm/
git commit -m "Update iTerm2 configuration"
git push
```

To export individual profiles or color schemes:
- Profiles: Preferences → Profiles → Other Actions → Save Profile as JSON
- Color schemes: Preferences → Profiles → Colors → Color Presets → Export

**First-Time Setup**:
- Install [Powerline fonts](https://github.com/powerline/fonts) or MesloLGM Nerd Font
- Restart iTerm2 after installation to load all settings
- Color schemes and profiles will be automatically available
