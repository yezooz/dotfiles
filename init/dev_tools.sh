#!/usr/bin/env bash

if is_macos; then
    brew install --cask adoptopenjdk mysqlworkbench
    brew install go readline awscli pgcli ruby terraform terraform_landscape composer lua jq node mysql-client nmap php aws-iam-authenticator

    # Docker
    # brew install --cask docker docker-toolbox
    brew install docker-completion docker-compose-completion

    # K8s
    brew install kubectl eksctl k9s helm kubectx

    # NPM
    # npm -g install nodemon @nestjs/cli

    # Editors
    # brew cask install sublime-text visual-studio-code intellij-idea phpstorm pycharm webstorm datagrip goland

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