#!/usr/bin/env bash

if is_macos; then
  source $(brew --prefix)/etc/bash_completion.d/goto.sh

  completions=(goto.sh kubectx kubens pipx youtube-dl.bash-completion)
  for c in $completions; do
    c="$(brew --prefix)/etc/bash_completion.d/${c}"
    [[ -r "${c}" ]] && source "${c}";
  done

  if [ -x "$(command -v pipx)" ]; then
    # export PATH="$PATH:$HOME/.local/bin"
    eval "$(register-python-argcomplete pipx)"
  fi

  if [ -x "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
  fi

  if [ -x "$(command -v vault)" ]; then
    complete -o nospace -C /usr/local/bin/vault vault
  fi

  if [ -e "$HOME/.ssh/config" ]; then
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
  fi

  export DIRENV_LOG_FORMAT=$'\E[1mdirenv: %s\E[0m'
  eval "$(direnv hook zsh)"
fi

[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
# source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh
