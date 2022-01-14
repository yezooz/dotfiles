#!/usr/bin/env bash

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
	sudo add-apt-repository -y $1
	sudo apt update
	sudo apt install -y $2
}

export DOTFILES=~/.dotfiles

add_path $DOTFILES/bin

sudo apt-get -qq update && sudo apt-get -qq dist-upgrade
sudo apt install -y git ssh build-essential curl file screen mc tree curl wget htop xclip software-properties-common gcc make libpq-dev python-dev apt-transport-https ca-certificates gnupg-agent gnupg2 build-essential jq silversearcher-ag tree fonts-powerline pipx

# Docker
if [[ ! "$(type -P docker)" ]]; then
	echo "Installing Docker"

	sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
	sudo apt install -y docker-ce docker-compose
	sudo addgroup --system docker
	sudo usermod -aG docker ${USER}
else
	echo "Docker already installed"
fi

# Homebrew
if [[ ! -d ~/.linuxbrew/Homebrew ]]; then
	echo "Installing Homebrew"

	git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	mkdir ~/.linuxbrew/bin
	ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
	~/.linuxbrew/bin/brew
else
	echo "Homebrew already installed"
fi

add_path ~/.linuxbrew/bin

# Git
[[ ! -L ~/.gitconfig ]] && ln -s $DOTFILES/git/gitconfig ~/.gitconfig
[[ ! -L ~/.gitignore ]] && ln -s $DOTFILES/git/gitignore ~/.gitignore

# Zsh
if [[ ! "$(type -P zsh)" ]]; then
	echo "Installing zsh"

	sudo apt install -y zsh
	chsh -s $(which zsh)

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
	echo "zsh already installed"
fi

# Zsh extensions
[[ ! -L ~/.zshrc ]] && ln -s $DOTFILES/zsh/zshrc ~/.zshrc
[[ ! -L ~/.p10k.zsh ]] && ln -s $DOTFILES/zsh/p10k.zsh ~/.p10k.zsh
[[ ! -L ~/.zfunc ]] && ln -s $DOTFILES/zsh/zfunc ~/.zfunc

backup_and_link bashrc bash
backup_and_link bash_profile bash
backup_and_link zshrc zsh
backup_and_link p10k.zsh zsh

if [[ ! "$(type -P brew)" ]]; then
	echo "brew still not installed"
	exit 1
fi

# fzf
if [[ ! "$(type -P fzf)" ]]; then
	brew install fzf
	$BREW_PREFIX/opt/fzf/install
fi

# https://github.com/iridakos/goto
if [[ ! "$(type -P goto)" ]]; then
    brew install goto
    echo -e "\$include /etc/inputrc\nset colored-completion-prefix on" >> ~/.inputrc
fi

# https://github.com/ryanoasis/nerd-fonts
[[ ! -d ~/.local/share/fonts ]] && mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

# https://github.com/rvm/ubuntu_rvm
add_repo_and_install ppa:rael-gc/rvm rvm

# https://github.com/rbenv/ruby-build/wiki
sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev libncurses5-dev libffi-dev libgdbm-dev zlib1g-dev

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-16-04
# add_repo_and_install ppa:ansible/ansible ansible

# http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/
if [[ ! "$(type -P vim)" ]]; then
    add_repo_and_install ppa:jonathonf/vim vim
fi
[[ ! -d ~/.vim/bundle ]] && mkdir -p ~/.vim/bundle
[[ ! -d ~/.vim/bundle/Vundle.vim ]] && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [[ ! -L ~/.vimrc ]]; then
    mv ~/.vimrc ~/.vimrc.old 2>/dev/null
    ln -s $DOTFILES/vimrc ~/.vimrc
fi
[[ ! -L ~/.vim/colors ]] && ln -s $DOTFILES/vim/colors ~/.vim/colors

if [[ ! "$(type -P tmux)" ]]; then
    sudo apt install -y tmux
fi

[[ ! -L ~/.tmux.conf ]] && ln -s $DOTFILES/tmux.conf ~/.tmux.conf
[[ ! -d ~/.tmux/plugins ]] && mkdir -p ~/.tmux/plugins
[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# https://github.com/greymd/tmux-xpanes
if [[ ! "$(type -P tmux-xpanes)" ]]; then
    add_repo_and_install ppa:greymd/tmux-xpanes tmux-xpanes
fi

brew install exa chroma

brew install docker-completion docker-compose docker-compose-completion

# K8s
# brew install kubectl eksctl k9s helm kubectx

echo "DONE!"