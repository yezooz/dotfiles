# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for macOS and Linux (Ubuntu). Configures shell (Zsh/Oh-My-Zsh/Powerlevel10k), Tmux, Neovim (LazyVim), Git, and development tools.

## Architecture

### Installation Flow

```
bootstrap.sh (one-click installer)
  ↓
init/preflight.sh (system checks)
  ↓
init/wizard.sh (interactive config)
  ↓
init/init.sh (main installer)
  ├→ init/macos.sh or init/ubuntu.sh (base setup)
  ├→ brew.sh (optional: GNU utils, modern CLI tools)
  ├→ init/dev_tools.sh (optional: languages, cloud, databases)
  ├→ init/desktop_tools.sh (optional: GUI apps)
  ├→ init/npm_packages.sh (optional: npm globals)
  ├→ init/uv_tools.sh (optional: Python tools via UV)
  ├→ mac/macos_defaults.sh (optional: macOS settings)
  └→ mac/dock_config.sh (optional: Dock config)
  ↓
init/verify.sh (post-install checks)
```

### Key Components

**`bin/dotfiles`** - Utility library providing:
- Logging: `e_header`, `e_success`, `e_error`, `e_arrow`
- OS detection: `is_macos()`, `is_linux()`, `is_ubuntu()`, `is_ubuntu_desktop()`
- Loads shell config from `zsh/deps/` in order: path.zsh, exports.zsh, aliases.zsh, functions.zsh, autocomplete.zsh, bindkeys.zsh

**Zsh Configuration**:
`~/.zshrc` → sources `bin/dotfiles "source"` → loads all `zsh/deps/*.zsh` files → sources `~/.p10k.zsh`

**Configuration Symlinks**:
- `zsh/zshrc` → `~/.zshrc`
- `zsh/p10k.zsh` → `~/.p10k.zsh`
- `git/gitconfig` → `~/.gitconfig`
- `tmux.conf` → `~/.tmux.conf`

**Custom Git Commands**:
Scripts in `bin/git-*` become git subcommands (e.g., `git current-branch`)

## Commands

### Installation
```bash
# One-click install (recommended)
bash <(curl -fsSL https://raw.githubusercontent.com/yezooz/dotfiles/master/bootstrap.sh)

# Manual install (if already cloned)
cd ~/.dotfiles && /bin/bash init/init.sh

# Verify installation
/bin/bash ~/.dotfiles/init/verify.sh

# Install optional components individually
/bin/bash ~/.dotfiles/brew.sh                    # Homebrew packages
/bin/bash ~/.dotfiles/init/dev_tools.sh          # Dev tools
/bin/bash ~/.dotfiles/init/desktop_tools.sh      # Desktop apps
/bin/bash ~/.dotfiles/mac/dock_config.sh         # Dock config (macOS)
```

### Development
```bash
# Test shell config changes
source ~/.zshrc  # or: reload

# Debug shell loading
DEBUG=1 source ~/.zshrc

# Test installation scripts (idempotent, safe to re-run)
/bin/bash ~/.dotfiles/init/dev_tools.sh

# Verify installation
/bin/bash ~/.dotfiles/init/verify.sh
```

### Maintenance
```bash
# Update dotfiles
cd ~/.dotfiles && git pull

# Update packages
brew update && brew upgrade  # Homebrew
omz update                   # Oh-My-Zsh
```

## Script Development Conventions

When modifying installation scripts:

**Logging Functions** (from `bin/dotfiles`):
- `e_header "message"` - Bold section headers
- `e_success "message"` - Green checkmark for success
- `e_error "message"` - Red X for errors
- `e_arrow "message"` - Blue arrow for info

**Script Requirements**:
- Use `set -e` to exit on errors
- Source `bin/dotfiles "source"` to load utilities
- Be idempotent (safe to run multiple times)
- Check for existing installations before installing

## Performance Optimizations

### Startup Time Targets
- **Target:** ~150-200ms shell startup time
- **Current:** ~230ms (measured via `zsh-benchmark`)
- **Baseline (before optimizations):** ~500ms

### Key Optimizations

**NVM Lazy Loading** (~300-500ms savings)
- Defers NVM initialization until first Node command (`node`, `npm`, `npx`, `nvm`)
- Provides instant shell startup while preserving all functionality
- Disable lazy loading: `export NVM_LAZY_LOAD=0` in `~/.zshrc.local`
- Implementation: `zsh/deps/exports.zsh`

**Completion Caching** (~20-40ms savings)
- Caches completion dump for 24 hours
- Skips `compinit` security check when cache is fresh (< 24h old)
- Automatically regenerates when stale
- Implementation: `zsh/deps/autocomplete.zsh`

**P10k Prompt Optimization** (~50-100ms savings)
- Reduced right prompt from 21 to 8 essential segments
- Removed redundant version managers (nodenv, nodeenv, node_version)
- Removed rarely-used segments (toolbox, vim_shell, midnight_commander, terraform, etc.)
- Kept essential: status, timing, jobs, virtualenv, nvm, k8s, aws, context
- Re-enable specific segments by uncommenting in `zsh/p10k.zsh`

**Command Existence Check Optimization** (~10-20ms savings)
- Standardized on fast `command -v foo &>/dev/null` pattern
- Replaced slower `[ -x "$(command -v foo)" ]` and `type -P` patterns
- Optimized 21+ checks across configuration files

### Performance Testing

```bash
# Benchmark average startup time (10 runs)
zsh-benchmark

# Profile to identify bottlenecks
zsh-profile

# Debug file loading times
DEBUG=1 source ~/.zshrc

# Health check
dotfiles-health  # or: dfh
```

### Performance Regression Prevention
- Always test startup time before/after configuration changes
- Keep P10k right prompt under 10 segments
- Lazy-load heavy tools (NVM, RVM, pyenv, etc.) when possible
- Avoid synchronous network calls during shell startup
- Use completion caching for large completion sets

### Local Overrides

Machine-specific settings that don't belong in version control:
- Create `~/.zshrc.local` for personal/work-specific configuration
- Template available at `zsh/zshrc.local.example`
- Already gitignored - safe for secrets and API keys
- Loaded last in sequence, can override any setting

Example use cases:
- Work AWS profiles: `export AWS_VAULT_PROFILE="work_profile"`
- Machine-specific paths
- Personal aliases and functions
- API keys and tokens

## Important Details

### Installation Configuration

User preferences saved in `.install-config` (gitignored):
- Git user name/email
- Installation profile (minimal/developer/full)
- Component selections (auto-installed by init.sh)

Profiles:
- **Minimal**: Shell + Git + Neovim + Tmux
- **Developer**: Minimal + dev tools + Docker + Kubernetes
- **Full**: Developer + desktop apps

### Git Configuration

Git user.name and user.email are NOT in version control. Set via:
- Environment variables in `zsh/deps/exports.zsh`, OR
- `git config --global user.email "you@example.com"`

### Zsh Plugins

Active Oh-My-Zsh plugins (defined in `zsh/zshrc`):
- colorize, zsh-syntax-highlighting, zsh-autosuggestions, zsh-interactive-cd, zsh-window-title

### PATH Management

Configured in `zsh/deps/path.zsh`:
- Homebrew binaries, Go/Ruby/Python/Node paths, custom scripts from `~/.dotfiles/bin`

### iTerm2 Configuration (macOS)

iTerm2 settings are version controlled in `iterm/com.googlecode.iterm2.plist`. Auto-loaded during installation. To manually sync:
1. iTerm2 → Preferences → General → Preferences
2. Check "Load preferences from a custom folder"
3. Set path: `~/.dotfiles/iterm`
4. Check "Save changes to folder when iTerm2 quits" (enables auto-commit)

### Known Issues

**Mac App Store CLI (`mas`)**: Frequently fails on modern macOS. Install apps manually from App Store GUI if `mas install` errors occur.
