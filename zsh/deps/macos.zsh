#!/usr/bin/env bash

# test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# echo "Hello, Mac!"

# https://gist.github.com/Gram21/35dc66c4673bb63fa8c1

# Mac list open ports
alias show_open_ports="sudo lsof -i -n -P"
alias open_ports="show_open_ports"

# get public ip
alias show_public_ip="curl -Ss icanhazip.com"
alias public_ip="show_public_ip"
alias copy_public_ip="show_public_ip | pbcopy"
alias show_public_ip_v4="curl -Ss4 icanhazip.com/v4"
alias public_ip_v4="show_public_ip_v4"
alias copy_public_ip_v4="show_public_ip_v4 | pbcopy"
alias show_public_ip_v6="curl -Ss6 icanhazip.com/v6"
alias public_ip_v6="show_public_ip_v6"
alias copy_public_ip_v6="show_public_ip_v6 | pbcopy"

# osc show battery status
alias battery='pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto'
