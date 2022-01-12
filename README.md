# Use dotfiles

```bash
git submodule add https://github.com/iridakos/goto.git zsh/plugins/goto

```

## MacOS

### Reqs

```bash
DOTFILES=~/.dotfiles
sh $DOTFILES/init/macos.sh
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
DOTFILES=~/.dotfiles
sh $DOTFILES/init/ubuntu.sh
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
