# Use dotfiles

```bash
git submodule add https://github.com/iridakos/goto.git zsh/plugins/goto

```

## MacOS

### Reqs

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install git openssh fzf tree openssl python cmake wget freetype htop
brew cask
brew cask install iterm2 xquartz

# Zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# Zsh extensions
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/zsh/zfunc ~/.zfunc
ln -s ~/dotfiles/zsh/files/pre.zsh ~/.pre.zsh
ln -s ~/dotfiles/zsh/files/path.zsh ~/.path.zsh
ln -s ~/dotfiles/zsh/files/exports.zsh ~/.exports.zsh
ln -s ~/dotfiles/zsh/files/aliases.zsh ~/.aliases.zsh
ln -s ~/dotfiles/zsh/files/functions.zsh ~/.functions.zsh
ln -s ~/dotfiles/zsh/files/autocomplete.zsh ~/.autocomplete.zsh
ln -s ~/dotfiles/zsh/files/macos.zsh ~/.macos.zsh
ln -s ~/dotfiles/zsh/files/linux.zsh ~/.linux.zsh

# unlink ~/.zshrc
# unlink ~/.p10k.zsh
# unlink ~/.zfunc
# unlink ~/.pre.zsh
# unlink ~/.path.zsh
# unlink ~/.exports.zsh
# unlink ~/.aliases.zsh
# unlink ~/.functions.zsh
# unlink ~/.autocomplete.zsh
# unlink ~/.macos.zsh
# unlink ~/.linux.zsh

git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

# Vim
brew install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
pip3 install pynvim
mv ~/.vimrc ~/.vimrc.old 2>/dev/null
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/vim/colors ~/.vim/colors

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/gitignore ~/.gitignore
ln -s ~/dotfiles/gitmessage ~/.gitmessage
ln -s ~/dotfiles/git_template ~/.git_template

; Ruby
brew install ruby-install
ruby-install ruby-3.1.0 \
  --no-install-deps \
  -- \
  --without-X11 \
  --without-tk \
  --enable-shared \
  --disable-install-doc \
  --with-openssl-dir="$(brew --prefix openssl)"

```

Launch `vim` and run `:PluginInstall`

### Dev tools

```bash
brew cask install virtualbox virtualbox-extension-pack vagrant vagrant-manager adoptopenjdk mysqlworkbench ngrok
brew install go readline awscli awslogs pgcli ruby terraform terraform_landscape composer jmeter lua jq dep node clojure mysql-client nmap php prettier aws-iam-authenticator

; Docker
brew cask install docker docker-toolbox
brew install vagrant-completion docker-completion docker-compose docker-compose-completion docker-machine docker-machine-completion

; K8s
brew install kubectl eksctl k9s helm kubectx minikube

; NPM
npm -g install bower grunt nodemon eslint cypress @nestjs/cli

; Editors
brew cask install sublime-text visual-studio-code intellij-idea phpstorm pycharm webstorm datagrip goland
```

### Desktop tools

```bash
brew cask install alfred slack google-chrome firefox postman vlc spotify transmission whatsapp signal dropbox 1password the-unarchiver tor-browser karabiner-elements stats
brew install youtube-dl ffmpeg
```

### Extras

https://mwholt.blogspot.be/2012/09/fix-home-and-end-keys-on-mac-os-x.html

### iTerm

Install Powerline fonts for iTerm by following instructions on https://github.com/powerline/fonts

Themes https://github.com/mbadolato/iTerm2-Color-Schemes

## Ubuntu

### Reqs

```bash
./init/ubuntu.sh
```

### Dev tools

```bash
sudo apt-get update
sudo apt install -y vpnc
brew install terraform terragrunt terraform_landscape node typescript jsonnet go composer clojure aws-iam-authenticator pgcli
pip install --user tmuxp

; Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

; Docker
sudo addgroup --system docker
sudo adduser $USER docker
sudo snap install docker
newgrp docker
sudo snap restart docker
brew install docker-completion docker-compose docker-compose-completion

; K8s
brew install kubectl eksctl k9s helm kubectx
```

### Desktop tools

```bash
sudo snap install chromium postman vlc spotify whatsdesk
sudo snap install sublime-text --classic
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install filezilla --beta
```
