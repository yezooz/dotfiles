#!/usr/bin/env bash

if is_macos; then

    brew cask install virtualbox virtualbox-extension-pack vagrant vagrant-manager adoptopenjdk mysqlworkbench ngrok
    brew install go readline awscli awslogs pgcli ruby terraform terraform_landscape composer jmeter lua jq dep node clojure mysql-client nmap php prettier aws-iam-authenticator

    # Docker
    brew cask install docker docker-toolbox
    brew install vagrant-completion docker-completion docker-compose docker-compose-completion docker-machine docker-machine-completion

    # K8s
    brew install kubectl eksctl k9s helm kubectx minikube

    # NPM
    npm -g install bower grunt nodemon eslint cypress @nestjs/cli

    # Editors
    brew cask install sublime-text visual-studio-code intellij-idea phpstorm pycharm webstorm datagrip goland

elif is_ubuntu; then
    sudo apt-get update
    sudo apt install -y vpnc
    brew install terraform terragrunt terraform_landscape node typescript jsonnet go composer clojure aws-iam-authenticator pgcli
    pip install --user tmuxp

    # Ansible
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible

    # Docker
    sudo addgroup --system docker
    sudo adduser $USER docker
    sudo snap install docker
    newgrp docker
    sudo snap restart docker
    brew install docker-completion docker-compose docker-compose-completion

    # K8s
    brew install kubectl eksctl k9s helm kubectx
fi