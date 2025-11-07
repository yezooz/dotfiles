# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that configures development environments for both macOS and Linux (Ubuntu) systems. The setup includes shell configuration (Zsh with Oh-My-Zsh and Powerlevel10k), terminal tools (Tmux), editor config (Neovim/LazyVim), Git configuration, and various development tools.

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
  - Allows selection of optional components:
    - Homebrew packages (GNU utilities, modern CLI tools)
    - Development tools (languages, cloud, databases)
    - Desktop applications (GUI apps)
    - NPM global packages (@openai/codex, @playwright/mcp, yarn)
    - UV Python tools (llm, poetry, scrapy, etc.)
    - SSH key generation
    - macOS system defaults (macOS only)
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
- `init/dev_tools.sh` - Development tools organized by tiers:
  - **Core**: git, gh, glab, curl, wget, tree
  - **Developer**: Programming languages (Go, Rust, Python, Node.js, Ruby, PHP, Lua), package managers (mise, composer, yarn), utilities (direnv, pre-commit, cloc, jq)
  - **Cloud/DevOps**: AWS tools (awscli, aws-vault, eksctl), containers (podman, kind, docker-completion), Kubernetes (kubectl, helm, k9s, kubectx), IaC (terraform, terragrunt, ansible)
  - **Database**: mysql-client, postgresql, redis, sqlite, duckdb, pgcli
  - **GUI Apps**: adoptopenjdk, mysqlworkbench, postman
  - **JetBrains IDEs**: datagrip, phpstorm, pycharm (Pro), webstorm, goland
  - **Code Editors**: jupyterlab-app, typora
- `init/desktop_tools.sh` - Desktop applications (browsers, productivity, media)
  - Browsers: Chrome, Brave Browser, Tor Browser
  - Productivity: Alfred, 1Password, Karabiner Elements, Anki, Dictionaries, Kindle
  - Communication: Slack, Signal, Zoom
  - Media: VLC, Spotify, Pocket Casts, Transmission
  - Utilities: balenaEtcher, Focusrite Control 2
  - Mac App Store apps (via `mas`)
  - Manual installs: iTerm2, VS Code, Docker Desktop, Wispr Flow, Flow
- `init/npm_packages.sh` - NPM global packages
  - @openai/codex, @playwright/mcp, yarn
  - Configures npm to use `~/.npm-global` directory
- `init/uv_tools.sh` - UV Python tools
  - AI/LLM: llm
  - Development: poetry, pre-commit
  - Web Scraping: scrapy
  - Git: git-filter-repo
  - Text Processing: strip-tags, ttok
  - Auto-installs UV if not present
- `brew.sh` - Additional Homebrew packages (GNU utilities, modern CLI tools)
  - Core utilities: coreutils, moreutils, findutils, gnu-sed
  - Modern CLI tools: tmux, fzf, bat, ripgrep, fd, delta, btop, eza, jq
  - Development: git, git-lfs, gnupg, vim, grep, php
  - macOS utilities: dockutil (Dock management)
  - Utilities: wget, tree, rename, mas, quicklook plugins
- `mac/macos_defaults.sh` - macOS system preferences configuration
- `mac/dock_config.sh` - macOS Dock configuration
  - Dock appearance: position, size, magnification, auto-hide
  - Dock applications: programmatically add/remove apps
  - Requires dockutil (installed via brew.sh)
- `ssh.sh` - SSH key generation script (Ed25519 keys)

### Configuration Files

Symlinks are created from `~/.dotfiles/` to `~/`:
- `zsh/zshrc` → `~/.zshrc`
- `zsh/p10k.zsh` → `~/.p10k.zsh`
- `git/gitconfig` → `~/.gitconfig`
- `git/gitignore` → `~/.gitignore`
- `git/git_template` → `~/.git_template`
- `tmux.conf` → `~/.tmux.conf`
- `bashrc` → `~/.bashrc`

**Neovim Configuration**:
LazyVim is installed to `~/.config/nvim/` during setup:
- Uses the official [LazyVim starter](https://github.com/LazyVim/starter) configuration
- Provides modern Neovim setup with sensible defaults and plugin management
- Configuration is stored in `~/.config/nvim/` (not in dotfiles repo)

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
# Install additional Homebrew packages (GNU utils, modern CLI tools)
/bin/bash ~/.dotfiles/brew.sh

# Install development tools (languages, cloud, databases)
/bin/bash ~/.dotfiles/init/dev_tools.sh

# Install desktop applications
/bin/bash ~/.dotfiles/init/desktop_tools.sh

# Install NPM global packages
/bin/bash ~/.dotfiles/init/npm_packages.sh

# Install UV Python tools
/bin/bash ~/.dotfiles/init/uv_tools.sh

# LazyVim will auto-install plugins on first run of nvim
nvim

# Generate SSH key
/bin/bash ~/.dotfiles/ssh.sh your-email@example.com

# Configure macOS Dock (position, size, apps)
/bin/bash ~/.dotfiles/mac/dock_config.sh

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

# Update LazyVim plugins (from within nvim)
# Press <leader>L (Lazy) to open plugin manager, then 'U' to update

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
- Optional component selections:
  - Homebrew packages (GNU utilities, modern CLI tools like tmux, fzf, bat, ripgrep, fd, delta, btop)
  - Development tools (programming languages, cloud tools, databases)
  - Desktop applications (browsers, productivity, communication, media)
  - NPM global packages (@openai/codex, @playwright/mcp, yarn)
  - UV Python tools (llm, poetry, pre-commit, scrapy, git-filter-repo, strip-tags, ttok)
  - SSH key generation
  - macOS system defaults
- This file is gitignored and can be reused for updates or reconfiguration

Installation profiles:
- **Minimal**: Shell + Git + Neovim + Tmux (recommended for servers)
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

### Dock Configuration (macOS)

**Managing Dock Settings**:

The `mac/dock_config.sh` script allows you to configure the Dock via terminal:

```bash
# Configure Dock appearance and applications
/bin/bash ~/.dotfiles/mac/dock_config.sh
```

**Dock Settings** (configured via `defaults write`):
- Position: left, bottom, or right
- Icon size: 49 pixels (customizable)
- Magnification: enabled with 64px max size
- Auto-hide: enabled with minimal delay
- Minimize effect: scale (or genie/suck)
- Don't show recent applications

**Dock Applications** (managed via `dockutil`):
- Programmatically add/remove apps
- Maintain consistent Dock across machines
- Customize the app list in the script

**To customize**:
1. Edit `mac/dock_config.sh`
2. Modify the `add_to_dock` function calls
3. Add/remove apps as needed
4. Run the script to apply changes

**Manual Dock management**:
```bash
# Add an app
dockutil --add /Applications/AppName.app

# Remove an app
dockutil --remove "AppName"

# Remove all apps
dockutil --remove all

# List current Dock items
dockutil --list
```

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

## Installed Packages Reference

This section documents all packages installed by the dotfiles, organized by installation source.

### Homebrew Packages (brew.sh)

**Core Utilities**:
- coreutils, moreutils, findutils, gnu-sed - GNU utilities
- bash, bash-completion2 - Modern Bash shell
- wget, curl - Download tools
- gnupg - PGP signing
- grep, openssh, screen - System tools

**Modern CLI Tools**:
- tmux - Terminal multiplexer
- fzf - Fuzzy finder
- bat - Better cat with syntax highlighting
- ripgrep - Fast grep alternative
- fd - Better find alternative
- delta - Better git diff viewer
- btop - Interactive process viewer
- eza - Modern ls replacement
- jq - JSON processor
- tree - Directory tree viewer

**Development Tools**:
- git, git-lfs - Version control
- vim - Text editor
- ack - Code search tool
- cloc - Code line counter

**Utilities**:
- rename, p7zip, pigz, pv, zopfli - File utilities
- mas - Mac App Store CLI
- Quicklook plugins (qlcolorcode, qlstephen, qlmarkdown, etc.)

### Development Tools (init/dev_tools.sh)

**Programming Languages**:
- go (v1.25+) - Go programming language
- rust - Rust with cargo
- python@3.14 - Latest Python
- node@20 - Node.js LTS
- ruby - Ruby programming language
- php (v8.4+) - PHP programming language
- lua - Lua scripting language

**Version Control & Code Tools**:
- git, git-lfs - Version control
- gh - GitHub CLI
- glab - GitLab CLI

**Package Managers & Build Tools**:
- mise - Modern runtime manager
- composer - PHP package manager
- yarn - Node.js package manager
- direnv - Environment variable manager
- pre-commit - Git pre-commit hooks

**Cloud Tools - AWS**:
- awscli (v2) - AWS command-line interface
- aws-vault - AWS credential manager
- aws-iam-authenticator - AWS IAM for Kubernetes
- eksctl - Amazon EKS CLI

**Container Tools**:
- podman - Container engine (Docker alternative)
- kind - Kubernetes in Docker
- docker-completion, docker-compose-completion

**Kubernetes Tools**:
- kubectl - Kubernetes CLI
- helm - Kubernetes package manager
- k9s - Kubernetes TUI
- kubectx - Context/namespace switcher

**Infrastructure as Code**:
- terraform - Infrastructure provisioning
- terragrunt - Terraform wrapper
- terraform_landscape - Terraform output formatter
- ansible - Configuration management

**Database Clients**:
- mysql-client - MySQL CLI
- postgresql (libpq) - PostgreSQL client library
- redis - Redis CLI
- sqlite - SQLite database
- duckdb - DuckDB analytical database
- pgcli - PostgreSQL CLI with autocomplete

**Additional Tools**:
- nmap - Network scanner
- readline - Terminal line editing
- cloc - Code line counter

**GUI Development Tools**:
- adoptopenjdk - Java JDK
- mysqlworkbench - MySQL GUI
- postman - API testing

**JetBrains IDEs**:
- datagrip - Database IDE
- phpstorm - PHP IDE
- pycharm - Python IDE (Professional edition)
- webstorm - JavaScript/TypeScript IDE
- goland - Go IDE

**Code Editors & Notebooks**:
- jupyterlab-app - Jupyter notebook environment
- typora - Markdown editor (WYSIWYG)

### Desktop Applications (init/desktop_tools.sh)

**Browsers**:
- google-chrome - Google Chrome browser
- brave-browser - Privacy-focused browser
- tor-browser - Tor Browser

**Productivity & Utilities**:
- alfred - Application launcher
- 1password - Password manager
- karabiner-elements - Keyboard customization
- anki - Flashcard learning app
- dictionaries - Dictionary application
- kindle - Amazon Kindle eBook reader

**Communication**:
- slack - Team communication
- signal - Private messaging
- zoom - Video conferencing

**Development GUI Tools**:
- postman - API testing
- mysqlworkbench - MySQL GUI
- datagrip - JetBrains Database IDE
- phpstorm - JetBrains PHP IDE
- pycharm - JetBrains Python IDE (Professional)
- webstorm - JetBrains JavaScript/TypeScript IDE
- goland - JetBrains Go IDE
- jupyterlab-app - Jupyter notebook environment
- typora - Markdown editor (WYSIWYG)

**Media & Entertainment**:
- vlc - Media player
- spotify - Music streaming
- pocket-casts - Podcast player
- transmission - BitTorrent client
- yt-dlp - YouTube downloader (CLI)

**System Utilities**:
- balenaetcher - USB/SD card flasher
- focusrite-control-2 - Focusrite audio interface control software

**Mac App Store Apps** (installed via mas):
- Color Picker (1545870783)
- WhatsApp (1147396723)
- SnippetsLab (1006087419) - Code snippets manager
- Moom (419330170) - Window manager
- NextDNS (1464122853) - DNS manager
- rcmd (1596283165) - App switcher
- Unarchiver (425424353) - Archive utility
- MeetingBar (1532419400) - Calendar in menu bar
- Boop (1518425043) - Text transformer
- Tomito (1526042938) - Pomodoro timer
- Gestimer (990588172) - Simple timer
- Things (904280696) - Task manager

**Manually Installed Apps** (not available via Homebrew):
- iTerm2 - Terminal emulator (https://iterm2.com/)
- Visual Studio Code - Code editor (https://code.visualstudio.com/)
- Docker Desktop - Container platform (https://www.docker.com/products/docker-desktop)
- Wispr Flow - AI transcription/dictation (https://wispr.ai/)
- Flow - Task/project manager (install manually)

### NPM Global Packages (init/npm_packages.sh)

Installed to `~/.npm-global/`:
- @openai/codex - OpenAI Codex CLI
- @playwright/mcp - Playwright MCP server
- yarn - Alternative package manager
- npm (latest) - Node package manager

### UV Python Tools (init/uv_tools.sh)

Installed via UV tool manager:
- llm - Simon Willison's LLM CLI interface
- poetry - Python dependency management
- pre-commit - Git pre-commit hooks
- scrapy - Web scraping framework
- git-filter-repo - Git repository rewriting tool
- strip-tags - HTML tag stripper
- ttok - Token counter for LLMs

### Go Binaries (~/go/bin)

Installed via `go install`:
- dbtpl - Database template tool
- expvarmon - Expvar monitoring
- goimports - Go import management
- golangci-lint - Go linter aggregator
- gopls - Go language server
- govulncheck - Go vulnerability checker
- hey - HTTP load generator
- migrate - Database migration tool
- staticcheck - Go static analysis

### Ruby Gems

Notable gems (349 total):
- rails - Ruby on Rails framework
- bundler - Ruby dependency manager
- bundler-audit - Security auditing
- puma - Ruby web server
- sidekiq - Background job processing
- devise - Authentication solution
- jwt - JSON Web Token
- rubocop - Ruby linter/formatter (with plugins)

### Custom Scripts (bin/)

**Git Helper Scripts**:
- git-ca, git-churn, git-co-pr, git-create-branch, git-ctags
- git-current-branch, git-delete-branch, git-merge-branch
- git-pr, git-rename-branch, git-up

**Infrastructure Tools**:
- terraform (v1.12.2)
- terragrunt (v0.63.1)

**Utility Scripts**:
- dotfiles - Main utility script
- murder - Kill process by name
- rename, replace - Text utilities
- running - Check running processes
- ssid, wifi - WiFi utilities
- tat - Tmux attach helper

### Package Manager Summary

- **Homebrew**: Primary package manager (macOS/Linux)
- **NPM/Yarn**: Node.js packages
- **UV**: Python tools (isolated environments)
- **Go**: Go binaries via `go install`
- **Cargo**: Rust packages (installed but not actively used)
- **Gem**: Ruby packages (heavily used)
- **Composer**: PHP packages (installed but not actively used)
- **mas**: Mac App Store applications
