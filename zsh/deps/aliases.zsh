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
if command -v eza &>/dev/null; then
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

# Enable aliases to be sudo'ed
alias sudo="sudo "
alias dotfiles="cd $DOTFILES"
alias reload="clear && exec zsh"

# Performance monitoring
alias zsh-benchmark='for i in {1..10}; do time zsh -i -c exit; done'
alias zsh-profile='PROFILE_ZSH=1 zsh -i -c exit'
alias zsh-debug='DEBUG=1 source ~/.zshrc'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gf='git fetch'
alias gfa='git fetch --all'

alias gw='git worktree'
alias gwl='git worktree list'
# alias gwa='git worktree add' # Removed - function in functions.zsh provides enhanced functionality
alias gwr='git worktree remove'

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

alias claude-yolo="claude --allow-dangerously-skip-permissions"
alias claude-work="CLAUDE_CONFIG_DIR=~/.claude-work claude"
alias claude-work-yolo="CLAUDE_CONFIG_DIR=~/.claude-work claude --allow-dangerously-skip-permissions"

# Kube
if command -v kubectl &>/dev/null; then
    alias k="kubectl"
fi

# youtube-dl
if command -v yt-dlp &>/dev/null; then
    alias yt='yt-dlp -ciw -v -o "%(title)s.%(ext)s" --restrict-filenames'
    alias yt-mp3='yt-dlp -ciw -v -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 --restrict-filenames'
    alias yt-mp4='yt-dlp -ciw -v -o "%(title)s.%(ext)s" --merge-output-format mp4 --restrict-filenames'
fi

# dstask
if command -v dstask &>/dev/null; then
    alias t="dstask"
fi

# AWS Vault - configurable via environment variables
# Set these in your ~/.zshrc.local or environment:
#   export AWS_VAULT_PROFILE="your_profile_name"        # base profile  -> `av`
#   export AWS_VAULT_ADMIN_PROFILE="your_admin_profile" # admin profile -> `aav`
#   export AWS_VAULT_POWER_PROFILE="your_power_profile" # power profile  -> `apv`
#   export AWS_VAULT_1P_ITEM="AWS"  # 1Password item name for OTP
if command -v aws-vault &> /dev/null && command -v op &> /dev/null; then
    if [[ -n "$AWS_VAULT_PROFILE" ]]; then
        alias av="aws-vault exec --duration=12h ${AWS_VAULT_PROFILE} --mfa-token=\$(op item get \"${AWS_VAULT_1P_ITEM:-AWS}\" --otp)"
    fi
    if [[ -n "$AWS_VAULT_ADMIN_PROFILE" ]]; then
        alias aav="aws-vault exec --duration=1h ${AWS_VAULT_ADMIN_PROFILE} --mfa-token=\$(op item get \"${AWS_VAULT_1P_ITEM:-AWS}\" --otp)"
    fi
    # Power-developer role. No inline --mfa-token: relies on the cached ~12h
    # session + the `mfa_process` in ~/.aws/config, so 1Password is only
    # prompted when the session actually needs refreshing (~once per 12h).
    if [[ -n "$AWS_VAULT_POWER_PROFILE" ]]; then
        alias apv="aws-vault exec --duration=12h ${AWS_VAULT_POWER_PROFILE} --mfa-token=\$(op item get \"${AWS_VAULT_1P_ITEM:-AWS}\" --otp)"
    fi
fi
