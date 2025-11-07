#!/usr/bin/env bash

################################################################################
# macOS Installation Script
################################################################################
# Installs and configures all macOS-specific components
################################################################################

set -e

DOTFILES=~/.dotfiles
if [[ ! -d $DOTFILES ]]; then
	e_error "Dotfiles directory not found at $DOTFILES"
	exit 1
fi

# Load config if available
CONFIG_FILE="${DOTFILES}/.install-config"
if [[ -f "$CONFIG_FILE" ]]; then
	source "$CONFIG_FILE"
fi

function backup_and_link() {
	[[ -L ~/.$1 ]] && unlink ~/.$1 && echo "unlink ~/.$1"
	[[ -f ~/.$1 ]] && mv ~/.$1 ~/.$1.old 2>/dev/null && echo "mv ~/.$1 ~/.$1.old"
	ln -s $DOTFILES/$2/$1 ~/.$1 && echo "ln -s $DOTFILES/$2/$1 ~/.$1"
}

function add_path() {
	[[ :$PATH: == *:$1:* ]] || export PATH="$1:$PATH"
	echo "updated PATH: $PATH"
}

# Homebrew
if [[ ! "$(type -P brew)" ]]; then
    e_header "Installing Homebrew"
    e_arrow "This will download and execute the official Homebrew install script"
    e_arrow "Review the script at: https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    echo ""

    # Check if in non-interactive mode
    if [[ -z "${DOTFILES_NONINTERACTIVE}" ]]; then
        read -p "Continue with Homebrew installation? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            e_error "Homebrew installation cancelled"
            echo "Install manually with:"
            echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    fi

    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        e_success "Homebrew installed successfully"
    else
        e_error "Homebrew installation failed"
        exit 1
    fi
else
    e_success "Homebrew already installed"
fi

# brew install git openssh fzf tree openssl python cmake wget freetype htop
# brew --cask install iterm2 xquartz

# Zsh
if [[ ! "$(type -P zsh)" ]]; then
    e_header "Installing Zsh"
    if brew install zsh; then
        e_success "Zsh installed successfully"
    else
        e_error "Failed to install Zsh"
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
    "TamCore/autoupdate-oh-my-zsh-plugins:autoupdate"
    "marlonrichert/zsh-autocomplete:zsh-autocomplete:--depth 1"
    "olets/zsh-window-title:zsh-window-title"
    "zsh-users/zsh-autosuggestions:zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting:zsh-syntax-highlighting"
)

for plugin_info in "${plugins[@]}"; do
    IFS=':' read -r repo plugin_name extra_flags <<< "$plugin_info"
    plugin_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin_name"

    if [[ ! -d "$plugin_dir" ]]; then
        e_arrow "Installing $plugin_name..."
        if git clone $extra_flags "https://github.com/$repo.git" "$plugin_dir"; then
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

# https://github.com/ryanoasis/nerd-fonts
# cd ~/Library/Fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

# dotfiles directory
# dotfiledir=${homedir}/dotfiles

# list of files/folders to symlink in ${homedir}
# files="bash_profile bashrc bash_prompt aliases private"

# change to the dotfiles directory
# echo "Changing to the ${dotfiledir} directory"
# cd ${dotfiledir}
# echo "...done"

# create symlinks (will overwrite old dotfiles)
# for file in ${files}; do
#     echo "Creating symlink to $file in home directory."
#     ln -sf ${dotfiledir}/.${file} ${homedir}/.${file}
# done

# Install Neovim
if [[ ! "$(type -P nvim)" ]]; then
	e_header "Installing Neovim"
	if brew install neovim; then
		e_success "Neovim installed successfully"
	else
		e_error "Failed to install Neovim"
	fi
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

# Ruby
# if [[ ! "$(type -P ruby)" ]]; then
# 	brew install ruby-install
# 	ruby-install ruby-3.1.0 \
# 	--no-install-deps \
# 	-- \
# 	--without-X11 \
# 	--without-tk \
# 	--enable-shared \
# 	--disable-install-doc \
# 	--with-openssl-dir="$(brew --prefix openssl)"
# fi

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

if [[ ! -L ~/.git_template ]]; then
    if ln -s $DOTFILES/git/git_template ~/.git_template; then
        e_success "Symlinked ~/.git_template"
    else
        e_error "Failed to symlink ~/.git_template"
    fi
else
    e_success "~/.git_template already symlinked"
fi

[[ ! -L ~/.gitconfig ]] && ln -s $DOTFILES/git/gitconfig ~/.gitconfig
[[ ! -L ~/.gitignore ]] && ln -s $DOTFILES/git/gitignore ~/.gitignore
[[ ! -L ~/.git_template ]] && ln -s $DOTFILES/git/git_template ~/.git_template

e_header "Configure iTerm to load preferences from dotfiles directory"
# This ensures all themes, profiles, key bindings, and settings are version controlled
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

e_success "macOS installation complete!"