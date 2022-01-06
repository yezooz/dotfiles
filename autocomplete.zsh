#!/usr/bin/env bash

autoload -U +X bashcompinit && bashcompinit

# pipx
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

# Direnv
  export DIRENV_LOG_FORMAT=""
  eval "$(direnv hook zsh)"

[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
