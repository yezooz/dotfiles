#!/usr/bin/env bash

if is_macos; then

    brew cask install alfred slack google-chrome firefox postman vlc spotify transmission signal dropbox 1password tor-browser karabiner-elements stats
    brew install yt-dlp mas

    mas install 1545870783 # Color Picker
    mas install 1147396723 # WhatsApp
    mas install 1529448980 # Reeder
    mas install 1006087419 # SnippetsLab
    mas install 419330170 # Moom
    mas install 1464122853 # NextDNS
    mas install 1596283165 # rcmd
    mas install 425424353 # Unarchiver
    mas install 1532419400 # MeetingBar
    mas install 1518425043 # Boop
    mas install 1526042938 # Tomito
    mas install 990588172 # Gestimer
    mas install 904280696 # Things

elif is_ubuntu; then
    sudo snap install chromium postman vlc spotify whatsdesk
    sudo snap install sublime-text --classic
    sudo snap install code --classic
    sudo snap install slack --classic
    sudo snap install filezilla --beta
fi