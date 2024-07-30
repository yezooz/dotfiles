#!/usr/bin/env bash

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias d="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
# alias p="cd ~/code"
alias c="clear"
alias e="$EDITOR"
alias v="$VISUAL"

alias path='echo $PATH | tr -s ":" "\n"'
command -v vim > /dev/null && alias vi="$(which vim)"

# alias ll="ls -lahF --color=auto"
if [ -x "$(command -v eza)" ]; then
    alias ls="eza --icons --group-directories-first --all"
    alias ll="eza --icons --group-directories-first --long --all"
    alias lt="eza --tree --long --all --header --group"
    alias lg="eza --icons --group-directories-first --grid --all"
fi

# alias g="goto"
alias grep="grep --color"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias mk="mkdir -p "$@" && cd "$@""

# Enable aliases to be sudo’ed
alias sudo="sudo "
alias dotfiles="cd $DOTFILES"
alias reload="clear && exec zsh"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Trim new lines and copy to clipboard
# alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Kube
if [ -x "$(command -v kubectl)" ]; then
    alias k="kubectl"
fi

# youtube-dl
if [ -x "$(command -v yt-dlp)" ]; then
    alias yt='yt-dlp -ciw -v -o "%(title)s.%(ext)s" --restrict-filenames'
    alias yt-mp3='yt-dlp -ciw -v -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 --restrict-filenames'
    alias yt-mp4='yt-dlp -ciw -v -o "%(title)s.%(ext)s" --merge-output-format mp4 --restrict-filenames'
fi

# dstask
if [ -x "$(command -v dstask)" ]; then
    alias t="dstask"
fi