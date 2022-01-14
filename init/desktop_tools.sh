#!/usr/bin/env bash

if is_macos; then

    brew cask install alfred slack google-chrome firefox postman vlc spotify transmission whatsapp signal dropbox 1password the-unarchiver tor-browser karabiner-elements stats
    brew install youtube-dl ffmpeg

elif is_ubuntu; then
    sudo snap install chromium postman vlc spotify whatsdesk
    sudo snap install sublime-text --classic
    sudo snap install code --classic
    sudo snap install slack --classic
    sudo snap install filezilla --beta
fi