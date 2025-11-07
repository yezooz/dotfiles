# Dotfiles

Personal development environment configuration files (dotfiles) for Mac and Linux systems.

## Features

- **Shell**: Zsh with Oh-My-Zsh, Powerlevel10k theme, and useful plugins
- **Terminal**: Tmux configuration with custom settings
- **Editor**: Vim with Vundle plugin manager
- **Git**: Custom git configuration and helpful aliases
- **Development Tools**: Docker, Kubernetes, AWS CLI, and more
- **Package Management**: Homebrew support on both Mac and Linux

---

## macOS Setup

### Prerequisites

1. **Install Xcode Command Line Tools** (required for compiling software):
   ```bash
   xcode-select --install
   ```

2. **Verify Git is installed**:
   ```bash
   git --version
   ```

### Installation Steps

1. **Clone this repository**:
   ```bash
   git clone https://github.com/yezooz/dotfiles.git ~/.dotfiles
   ```

2. **Run the main installation script**:
   ```bash
   cd ~/.dotfiles
   /bin/bash -c "~/.dotfiles/init/init.sh"
   ```

   This script will:
   - Install Homebrew (if not present)
   - Install Zsh and Oh-My-Zsh with plugins (Powerlevel10k, autosuggestions, syntax highlighting, etc.)
   - Set up symbolic links for configuration files (.zshrc, .gitconfig, etc.)
   - Install essential command-line tools (exa, chroma, docker-completion)

3. **Install additional Homebrew packages** (optional):
   ```bash
   /bin/bash -c "~/.dotfiles/brew.sh"
   ```

   This installs:
   - GNU utilities (coreutils, findutils, gnu-sed)
   - Modern tools (wget, vim, grep, openssh)
   - Development tools (git, gnupg, imagemagick, etc.)

4. **Install development tools** (optional):
   ```bash
   /bin/bash -c "~/.dotfiles/init/dev_tools.sh"
   ```

   This installs:
   - Programming languages: Go, Ruby, Node.js, PHP, Lua, Clojure
   - Databases: MySQL client, PostgreSQL client (pgcli)
   - Cloud tools: AWS CLI, Terraform, Terragrunt
   - Containers: Docker, Docker Compose, Kubernetes (kubectl, eksctl, k9s, helm)

5. **Install desktop applications** (optional):
   ```bash
   /bin/bash -c "~/.dotfiles/init/desktop_tools.sh"
   ```

   This installs apps via Homebrew and Mac App Store:
   - Productivity: Alfred, 1Password, Slack, Things
   - Browsers: Chrome, Firefox, Tor Browser
   - Media: Spotify, VLC
   - Utilities: Karabiner, Stats, Moom, and more

6. **Set up Vim plugins**:
   ```bash
   vim +PluginInstall +qall
   ```

7. **Restart your terminal** to apply all changes.

### Post-Installation (macOS)

- **iTerm2 Setup**:
  - Install [Powerline fonts](https://github.com/powerline/fonts)
  - Import color schemes from [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)

- **Fix Home/End Keys**: Follow [this guide](https://mwholt.blogspot.be/2012/09/fix-home-and-end-keys-on-mac-os-x.html)

- **SSH Key Setup** (optional):
  ```bash
  /bin/bash -c "~/.dotfiles/ssh.sh your-email@example.com"
  pbcopy < ~/.ssh/id_ed25519.pub  # Copy public key to clipboard
  ```
  Then add the key to your GitHub account.

---

## Linux (Ubuntu) Setup

### Prerequisites

1. **Ensure Git is installed**:
   ```bash
   sudo apt-get update
   sudo apt-get install -y git
   ```

2. **Create user account** (if setting up a new system):
   ```bash
   sudo adduser $USERNAME
   sudo usermod -aG sudo $USERNAME
   su - $USERNAME  # Switch to new user
   ```

### Installation Steps

1. **Clone this repository**:
   ```bash
   git clone https://github.com/yezooz/dotfiles.git ~/.dotfiles
   ```

2. **Run the main installation script**:
   ```bash
   cd ~/.dotfiles
   /bin/bash -c "~/.dotfiles/init/init.sh"
   ```

   This script will:
   - Update system packages
   - Install essential tools (git, build-essential, curl, wget, htop, etc.)
   - Install Docker and Docker Compose
   - Install Homebrew for Linux
   - Install Zsh and Oh-My-Zsh with plugins (Powerlevel10k, autosuggestions, syntax highlighting, etc.)
   - Set up symbolic links for configuration files
   - Install and configure Vim with Vundle
   - Install and configure Tmux
   - Install additional tools (fzf, goto, exa, chroma)
   - Download and install Nerd Fonts

3. **Add yourself to the docker group** (requires logout/login):
   ```bash
   sudo usermod -aG docker ${USER}
   ```

   Then log out and log back in for the group change to take effect.

4. **Install development tools** (optional):
   ```bash
   /bin/bash -c "~/.dotfiles/init/dev_tools.sh"
   ```

   This installs:
   - Programming languages: Terraform, Terragrunt, Node.js, TypeScript, Jsonnet, Go, Composer, Clojure
   - Cloud tools: AWS IAM Authenticator
   - Database tools: pgcli
   - Containers: Kubernetes tools (kubectl, eksctl, k9s, helm, kubectx)
   - Configuration management: Ansible
   - Session management: tmuxp

5. **Install desktop applications** (optional, for Ubuntu Desktop):
   ```bash
   /bin/bash -c "~/.dotfiles/init/desktop_tools.sh"
   ```

   This installs via snap:
   - Browsers: Chromium
   - Development: Sublime Text, VS Code, Postman
   - Communication: Slack, WhatsApp Desktop
   - Media: VLC, Spotify
   - Utilities: FileZilla

6. **Set up Vim plugins**:
   ```bash
   vim +PluginInstall +qall
   ```

7. **Change default shell to Zsh** (if not already done):
   ```bash
   chsh -s $(which zsh)
   ```

8. **Restart your terminal** or log out and log back in to apply all changes.

### Post-Installation (Linux)

- **SSH Key Setup** (optional):
  ```bash
  /bin/bash -c "~/.dotfiles/ssh.sh your-email@example.com"
  cat ~/.ssh/id_ed25519.pub  # Display public key
  ```
  Then add the key to your GitHub account.

- **Font Configuration**: The setup automatically downloads Nerd Fonts to `~/.local/share/fonts`. Configure your terminal emulator to use "Droid Sans Mono Nerd Font".

- **Tmux Plugin Manager**: Press `prefix + I` (default: `Ctrl+b` then `Shift+i`) in Tmux to install plugins.

---

## Configuration Files

After installation, the following files will be symlinked to your home directory:

- `~/.zshrc` → Zsh configuration
- `~/.p10k.zsh` → Powerlevel10k theme configuration
- `~/.gitconfig` → Git configuration
- `~/.gitignore` → Global Git ignore patterns
- `~/.vimrc` → Vim configuration
- `~/.tmux.conf` → Tmux configuration
- `~/.bashrc` → Bash configuration (backup)

## Customization

You can customize the configuration by editing files in the `~/.dotfiles` directory:

- **Zsh**: Edit `~/.dotfiles/zsh/zshrc`
- **Git**: Edit `~/.dotfiles/git/gitconfig` (remember to set your email via 1Password)
- **Vim**: Edit `~/.dotfiles/vimrc`
- **Tmux**: Edit `~/.dotfiles/tmux.conf`

Changes will be reflected immediately since these files are symlinked.

## Maintenance

### Update dotfiles
```bash
cd ~/.dotfiles
git pull origin main
```

### Update Homebrew packages
```bash
brew update && brew upgrade
```

### Update Oh-My-Zsh
```bash
omz update
```

### Update Vim plugins
```bash
vim +PluginUpdate +qall
```

---

## Troubleshooting

### macOS: "Command Line Tools not found"
Run `xcode-select --install` and retry the installation.

### Linux: "Permission denied" when using Docker
Make sure you've added yourself to the docker group and logged out/in:
```bash
sudo usermod -aG docker ${USER}
```

### Zsh not loading correctly
Ensure the symlinks are correct:
```bash
ls -la ~/.zshrc ~/.p10k.zsh
```

### Homebrew not found (Linux)
Add to your PATH (should be automatic after restart):
```bash
export PATH="$HOME/.linuxbrew/bin:$PATH"
```

---

## TODO

- https://sharats.me/posts/shell-script-best-practices/
- Use zaparseopts - https://xpmo.gitlab.io/post/using-zparseopts
