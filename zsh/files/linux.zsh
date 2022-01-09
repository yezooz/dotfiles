#!/usr/bin/env bash

# Caps Lock as ESC for Vim
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

# find out which distribution we are running on
_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')

# case $_distro in
#     *kali*)                  ICON="ﴣ";;
#     *arch*)                  ICON="";;
#     *debian*)                ICON="";;
#     *raspbian*)              ICON="";;
#     *ubuntu*)                ICON="";;
#     *elementary*)            ICON="";;
#     *fedora*)                ICON="";;
#     *coreos*)                ICON="";;
#     *gentoo*)                ICON="";;
#     *mageia*)                ICON="";;
#     *centos*)                ICON="";;
#     *opensuse*|*tumbleweed*) ICON="";;
#     *sabayon*)               ICON="";;
#     *slackware*)             ICON="";;
#     *linuxmint*)             ICON="";;
#     *alpine*)                ICON="";;
#     *aosc*)                  ICON="";;
#     *nixos*)                 ICON="";;
#     *devuan*)                ICON="";;
#     *manjaro*)               ICON="";;
#     *rhel*)                  ICON="";;
#     *)                       ICON="";;
# esac

# echo "Hello, $_distro Linux!"