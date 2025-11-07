# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that configures development environments for both macOS and Linux (Ubuntu) systems. The setup includes shell configuration (Zsh with Oh-My-Zsh and Powerlevel10k), terminal tools (Tmux), editor config (Vim), Git configuration, and various development tools.

## Architecture

### Entry Point
- `init/init.sh` - Main installation entry point that:
  - Sources `bin/dotfiles` for core functions and OS detection
  - Detects the OS (macOS/Ubuntu) and runs platform-specific installation scripts
  - Loads Zsh dependencies from `zsh/deps/` directory

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
- `init/macos.sh` - macOS setup: Homebrew, Zsh, Oh-My-Zsh plugins, symlinks config files
- `init/ubuntu.sh` - Ubuntu setup: System packages, Docker, Homebrew for Linux, fonts
- `init/_linux.sh` - Shared Linux utilities

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

### Custom Git Commands

The `bin/` directory contains custom git helper scripts (prefix `git-*`) that become available as git subcommands, e.g., `git-current-branch` can be called as `git current-branch`.

## Common Commands

### Installation
```bash
# Full fresh installation
cd ~/.dotfiles
/bin/bash -c "~/.dotfiles/init/init.sh"

# Install additional Homebrew packages
/bin/bash -c "~/.dotfiles/brew.sh"

# Install development tools
/bin/bash -c "~/.dotfiles/init/dev_tools.sh"

# Install desktop applications
/bin/bash -c "~/.dotfiles/init/desktop_tools.sh"

# Install Vim plugins
vim +PluginInstall +qall

# Generate SSH key
/bin/bash -c "~/.dotfiles/ssh.sh your-email@example.com"
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
