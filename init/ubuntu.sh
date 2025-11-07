#!/usr/bin/env bash

################################################################################
# Ubuntu Installation Script
################################################################################
# Installs and configures all Ubuntu-specific components
################################################################################

set -e

function backup_and_link() {
	[[ -L ~/.$1 ]] && unlink ~/.$1 && echo "unlink ~/.$1"
	[[ -f ~/.$1 ]] && mv ~/.$1 ~/.$1.old 2>/dev/null && echo "mv ~/.$1 ~/.$1.old"
	ln -s $DOTFILES/$2/$1 ~/.$1 && echo "ln -s $DOTFILES/$2/$1 ~/.$1"
}

function add_path() {
	[[ :$PATH: == *:$1:* ]] || export PATH="$1:$PATH"
	echo "updated PATH: $PATH"
}

function add_repo_and_install() {
	e_arrow "Adding repository: $1"
	sudo add-apt-repository -y $1
	sudo apt update -qq
	e_arrow "Installing: $2"
	sudo apt install -y $2
}

export DOTFILES=~/.dotfiles

if [[ ! -d $DOTFILES ]]; then
	e_error "Dotfiles directory not found at $DOTFILES"
	exit 1
fi

# Load config if available
CONFIG_FILE="${DOTFILES}/.install-config"
if [[ -f "$CONFIG_FILE" ]]; then
	source "$CONFIG_FILE"
fi

add_path $DOTFILES/bin

# Update system packages
e_header "Updating system packages"
if sudo apt-get -qq update && sudo apt-get -qq dist-upgrade -y; then
	e_success "System packages updated"
else
	e_error "Failed to update system packages"
	exit 1
fi

# Install essential packages
e_header "Installing essential packages"
essential_packages="git ssh build-essential curl file screen mc tree wget htop xclip software-properties-common gcc make libpq-dev python3-dev apt-transport-https ca-certificates gnupg-agent gnupg2 jq silversearcher-ag fonts-powerline pipx"

if sudo apt install -y $essential_packages; then
	e_success "Essential packages installed"
else
	e_error "Failed to install essential packages"
	exit 1
fi

# Docker
if [[ ! "$(type -P docker)" ]]; then
	e_header "Installing Docker"

	if sudo apt install -y apt-transport-https ca-certificates curl software-properties-common; then
		e_success "Docker prerequisites installed"
	else
		e_error "Failed to install Docker prerequisites"
		exit 1
	fi

	e_arrow "Adding Docker GPG key..."
	if curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -; then
		e_success "Docker GPG key added"
	else
		e_error "Failed to add Docker GPG key"
		exit 1
	fi

	e_arrow "Adding Docker repository..."
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

	e_arrow "Installing Docker CE and Docker Compose..."
	if sudo apt install -y docker-ce docker-compose; then
		e_success "Docker installed successfully"
	else
		e_error "Failed to install Docker"
		exit 1
	fi

	e_arrow "Adding user to docker group..."
	sudo groupadd docker 2>/dev/null || true
	sudo usermod -aG docker ${USER}
	e_success "User added to docker group (logout/login required)"
else
	e_success "Docker already installed"
fi

# Homebrew
if [[ ! -d ~/.linuxbrew/Homebrew ]]; then
	e_header "Installing Homebrew for Linux"

	e_arrow "Cloning Homebrew repository..."
	if git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew; then
		e_success "Homebrew cloned"
	else
		e_error "Failed to clone Homebrew"
		exit 1
	fi

	mkdir -p ~/.linuxbrew/bin
	ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin/brew

	if ~/.linuxbrew/bin/brew --version &> /dev/null; then
		e_success "Homebrew installed successfully"
	else
		e_error "Homebrew installation failed"
		exit 1
	fi
else
	e_success "Homebrew already installed"
fi

add_path ~/.linuxbrew/bin

# Create symlinks for Git config files
e_header "Creating Git config symlinks"

if [[ ! -L ~/.gitconfig ]]; then
	if ln -s $DOTFILES/git/gitconfig ~/.gitconfig; then
		e_success "Symlinked ~/.gitconfig"
	else
		e_error "Failed to symlink ~/.gitconfig"
	fi
else
	e_success "~/.gitconfig already symlinked"
fi

if [[ ! -L ~/.gitignore ]]; then
	if ln -s $DOTFILES/git/gitignore ~/.gitignore; then
		e_success "Symlinked ~/.gitignore"
	else
		e_error "Failed to symlink ~/.gitignore"
	fi
else
	e_success "~/.gitignore already symlinked"
fi

# Zsh
if [[ ! "$(type -P zsh)" ]]; then
	e_header "Installing Zsh"

	if sudo apt install -y zsh; then
		e_success "Zsh installed"

		e_arrow "Changing default shell to zsh..."
		if chsh -s $(which zsh); then
			e_success "Default shell changed to zsh"
		else
			e_warning "Failed to change shell automatically, run: chsh -s \$(which zsh)"
		fi
	else
		e_error "Failed to install zsh"
		exit 1
	fi
else
	e_success "Zsh already installed"
fi

# Install Oh-My-Zsh manually (safer than curl | sh)
if [[ ! -d ~/.oh-my-zsh ]]; then
	e_header "Installing Oh-My-Zsh"
	if git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh; then
		e_success "Oh-My-Zsh installed"
		e_arrow "The zshrc from dotfiles will configure Oh-My-Zsh"
	else
		e_error "Failed to install Oh-My-Zsh"
		exit 1
	fi
else
	e_success "Oh-My-Zsh already installed"
fi

# Install Powerlevel10k theme
if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
	e_header "Installing Powerlevel10k theme"
	if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k; then
		e_success "Powerlevel10k installed"
	else
		e_error "Failed to install Powerlevel10k"
	fi
else
	e_success "Powerlevel10k already installed"
fi

# Install Zsh plugins
e_header "Installing Zsh plugins"

plugins=(
	"zsh-users/zsh-syntax-highlighting:zsh-syntax-highlighting"
	"zsh-users/zsh-autosuggestions:zsh-autosuggestions"
	"olets/zsh-window-title:zsh-window-title"
)

for plugin_info in "${plugins[@]}"; do
	IFS=':' read -r repo plugin_name <<< "$plugin_info"
	plugin_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin_name"

	if [[ ! -d "$plugin_dir" ]]; then
		e_arrow "Installing $plugin_name..."
		if git clone "https://github.com/$repo.git" "$plugin_dir"; then
			e_success "$plugin_name installed"
		else
			e_error "Failed to install $plugin_name"
		fi
	else
		e_success "$plugin_name already installed"
	fi
done

# Create symlinks for Zsh config files
e_header "Creating Zsh config symlinks"

if [[ ! -L ~/.zshrc ]]; then
	if ln -s $DOTFILES/zsh/zshrc ~/.zshrc; then
		e_success "Symlinked ~/.zshrc"
	else
		e_error "Failed to symlink ~/.zshrc"
	fi
else
	e_success "~/.zshrc already symlinked"
fi

if [[ ! -L ~/.p10k.zsh ]]; then
	if ln -s $DOTFILES/zsh/p10k.zsh ~/.p10k.zsh; then
		e_success "Symlinked ~/.p10k.zsh"
	else
		e_error "Failed to symlink ~/.p10k.zsh"
	fi
else
	e_success "~/.p10k.zsh already symlinked"
fi

if [[ ! -L ~/.zfunc ]]; then
	if ln -s $DOTFILES/zsh/zfunc ~/.zfunc; then
		e_success "Symlinked ~/.zfunc"
	else
		e_error "Failed to symlink ~/.zfunc"
	fi
else
	e_success "~/.zfunc already symlinked"
fi

# Create additional bash symlinks
e_arrow "Creating bash config symlinks..."
backup_and_link bashrc bash
backup_and_link bash_profile bash

# Verify brew is available
if [[ ! "$(type -P brew)" ]]; then
	e_error "Homebrew not found in PATH"
	exit 1
else
	e_success "Homebrew is available"
fi

# Install fzf
if [[ ! "$(type -P fzf)" ]]; then
	e_header "Installing fzf"
	if brew install fzf && $BREW_PREFIX/opt/fzf/install --all --no-fish; then
		e_success "fzf installed"
	else
		e_error "Failed to install fzf"
	fi
else
	e_success "fzf already installed"
fi

# Install goto (directory bookmarking tool)
if [[ ! "$(type -P goto)" ]]; then
	e_header "Installing goto"
	if brew install goto; then
		e_success "goto installed"
		[[ ! -f ~/.inputrc ]] && echo -e "\$include /etc/inputrc\nset colored-completion-prefix on" >> ~/.inputrc
	else
		e_error "Failed to install goto"
	fi
else
	e_success "goto already installed"
fi

# Download Nerd Fonts
e_header "Installing Nerd Fonts"
[[ ! -d ~/.local/share/fonts ]] && mkdir -p ~/.local/share/fonts

if [[ ! -f ~/.local/share/fonts/"Droid Sans Mono for Powerline Nerd Font Complete.otf" ]]; then
	e_arrow "Downloading Droid Sans Mono Nerd Font..."
	if (cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf); then
		e_success "Nerd Font downloaded"
		fc-cache -f ~/.local/share/fonts 2>/dev/null || true
	else
		e_error "Failed to download Nerd Font"
	fi
else
	e_success "Nerd Font already installed"
fi

# Install RVM (optional, commented out by default)
# e_header "Installing RVM"
# add_repo_and_install ppa:rael-gc/rvm rvm

# Ruby build dependencies
e_header "Installing Ruby build dependencies"
if sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev libncurses5-dev libffi-dev libgdbm-dev zlib1g-dev; then
	e_success "Ruby dependencies installed"
else
	e_warning "Failed to install some Ruby dependencies"
fi

# Install Neovim
if [[ ! "$(type -P nvim)" ]]; then
	e_header "Installing Neovim"
	# Install latest stable neovim from PPA
	add_repo_and_install ppa:neovim-ppa/stable neovim
	e_success "Neovim installed"
else
	e_success "Neovim already installed"
fi

# Install LazyVim
if [[ ! -d ~/.config/nvim ]]; then
	e_header "Installing LazyVim"
	e_arrow "This will install the LazyVim starter configuration"

	# Backup existing neovim config if it exists
	[[ -d ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
	[[ -d ~/.local/share/nvim ]] && mv ~/.local/share/nvim ~/.local/share/nvim.backup.$(date +%Y%m%d_%H%M%S)
	[[ -d ~/.local/state/nvim ]] && mv ~/.local/state/nvim ~/.local/state/nvim.backup.$(date +%Y%m%d_%H%M%S)
	[[ -d ~/.cache/nvim ]] && mv ~/.cache/nvim ~/.cache/nvim.backup.$(date +%Y%m%d_%H%M%S)

	# Clone LazyVim starter
	if git clone https://github.com/LazyVim/starter ~/.config/nvim; then
		# Remove .git folder so it's not a submodule
		rm -rf ~/.config/nvim/.git
		e_success "LazyVim installed"
		e_arrow "Run 'nvim' to complete the installation"
	else
		e_error "Failed to install LazyVim"
	fi
else
	e_success "Neovim config already exists at ~/.config/nvim"
fi

# Install Tmux
if [[ ! "$(type -P tmux)" ]]; then
	e_header "Installing Tmux"
	if sudo apt install -y tmux; then
		e_success "Tmux installed"
	else
		e_error "Failed to install Tmux"
	fi
else
	e_success "Tmux already installed"
fi

# Setup Tmux configuration
e_header "Setting up Tmux"

if [[ ! -L ~/.tmux.conf ]]; then
	if ln -s $DOTFILES/tmux.conf ~/.tmux.conf; then
		e_success "Symlinked ~/.tmux.conf"
	else
		e_error "Failed to symlink ~/.tmux.conf"
	fi
else
	e_success "~/.tmux.conf already symlinked"
fi

[[ ! -d ~/.tmux/plugins ]] && mkdir -p ~/.tmux/plugins

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	e_arrow "Installing Tmux Plugin Manager..."
	if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; then
		e_success "TPM installed"
	else
		e_error "Failed to install TPM"
	fi
else
	e_success "TPM already installed"
fi

# Install tmux-xpanes (optional)
if [[ ! "$(type -P tmux-xpanes)" ]]; then
	e_header "Installing tmux-xpanes"
	add_repo_and_install ppa:greymd/tmux-xpanes tmux-xpanes
	e_success "tmux-xpanes installed"
else
	e_success "tmux-xpanes already installed"
fi

# Install essential CLI tools
e_header "Installing essential CLI tools"

tools=(
	"exa"
	"chroma"
	"docker-completion"
	"docker-compose"
	"docker-compose-completion"
)

for tool in "${tools[@]}"; do
	if ! brew list "$tool" &> /dev/null; then
		e_arrow "Installing $tool..."
		if brew install "$tool"; then
			e_success "$tool installed"
		else
			e_error "Failed to install $tool"
		fi
	else
		e_success "$tool already installed"
	fi
done

e_success "Ubuntu installation complete!"