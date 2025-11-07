# give us access to ^Q
# stty -ixon

# Only configure key bindings if we're in a Zsh shell (not during Bash installation)
if [[ -n "$ZSH_VERSION" ]]; then
  # vi mode
  bindkey -v
  bindkey "^F" vi-cmd-mode

  # handy keybindings
  bindkey "^A" beginning-of-line
  bindkey "^E" end-of-line
  bindkey "^K" kill-line
  bindkey "^R" history-incremental-search-backward
  bindkey "^P" history-search-backward
  bindkey "^Y" accept-and-hold
  bindkey "^N" insert-last-word
  bindkey "^Q" push-line-or-edit
  bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"
fi