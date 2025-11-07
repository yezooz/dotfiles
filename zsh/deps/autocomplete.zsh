#!/usr/bin/env zsh

completions=(goto.sh exa kubectx kubens)
for completion in "${completions[@]}"; do
  c="$BREW_PREFIX/etc/bash_completion.d/${completion}"
  [[ -r "${c}" ]] && source "${c}";
done

# if [ -x "$(command -v kubectl)" ]; then
#   source <(kubectl completion zsh)
# fi

# if [ -x "$(command -v dstask)" ]; then
#   source <(dstask zsh-completion)
# fi

if is_macos; then
  # Only run setopt if we're in a Zsh shell (not during Bash installation)
  if [[ -n "$ZSH_VERSION" ]]; then
    setopt completealiases
  fi

  if [ -x "$(command -v vault)" ]; then
    complete -o nospace -C /usr/local/bin/vault vault
  fi

  if [ -x "$(command -v op)" ]; then
    if [[ -n "$ZSH_VERSION" ]]; then
      eval "$(op completion zsh)"; compdef _op op
    fi
  fi

  # if [ -e "$HOME/.ssh/config" ]; then
  #   complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
  # fi

  # export DIRENV_LOG_FORMAT=$'\E[1mdirenv: %s\E[0m'
  # eval "$(direnv hook zsh)"
fi

# [[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
# source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh
