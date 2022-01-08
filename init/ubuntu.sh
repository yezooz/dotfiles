#!/usr/bin/env bash

sudo apt-get -qq update && sudo apt-get -qq dist-upgrade
sudo apt install -y git ssh build-essential curl file tmux screen mc tree curl wget htop xclip software-properties-common gcc make libpq-dev python-dev apt-transport-https ca-certificates gnupg-agent gnupg2 build-essential docker.io docker-compose jq silversearcher-ag tree fonts-powerline pipx

# Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce
sudo addgroup --system docker
sudo usermod -aG docker ${DEFAULT_USER}

git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir ~/.linuxbrew/bin
ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin

git clone https://github.com/yezooz/dotfiles.git ~/dotfiles

# Zsh
sudo apt install -y zsh
chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

mv ~/.bashrc ~/.bashrc.old 2>/dev/null
ln -s ~/dotfiles/bashrc ~/.bashrc
mv ~/.zshrc ~/.zshrc.old 2>/dev/null
ln -s ~/dotfiles/zshrc ~/.zshrc

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/gitignore ~/.gitignore
ln -s ~/dotfiles/gitmessage ~/.gitmessage
ln -s ~/dotfiles/git_template ~/.git_template

# Plugins
brew install fzf
$(brew --prefix)/opt/fzf/install

# https://github.com/iridakos/goto
brew install goto
echo -e "\$include /etc/inputrc\nset colored-completion-prefix on" >> ~/.inputrc

# https://github.com/ryanoasis/nerd-fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

# https://github.com/rvm/ubuntu_rvm
sudo add-apt-repository -y ppa:rael-gc/rvm
sudo apt install rvm

# https://github.com/rbenv/ruby-build/wiki
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev zlib1g-dev

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-16-04
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt install ansible

# http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/
sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

mv ~/.vimrc ~/.vimrc.old 2>/dev/null
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/vim/colors ~/.vim/colors

# https://launchpad.net/~hnakamur/+archive/ubuntu/tmux
sudo add-apt-repository -y ppa:hnakamur/tmux
sudo apt install tmux
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# https://github.com/greymd/tmux-xpanes
sudo add-apt-repository -y ppa:greymd/tmux-xpanes
sudo apt install tmux-xpanes

# brew install docker-completion docker-compose docker-compose-completion

# K8s
# brew install kubectl eksctl k9s helm kubectx