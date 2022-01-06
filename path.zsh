if [[ -n $MACOS ]]; then
  export PATH="$PATH:$HOME/.local/bin"
  export PATH="/usr/local/sbin:$PATH"

  # Go
  if [ -x "$(command -v go)" ]; then
    export GOROOT="/usr/local/opt/go/libexec"
    export GOPATH="$HOME/go"
    export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
  fi

  # Rust
  if [ -x "$(command -v cargo)" ]; then
    export PATH="$PATH:$HOME/.cargo/bin"
  fi

  # Composer
  if [ -x "$(command -v composer)" ]; then
    export PATH="$PATH:$HOME/.composer/vendor/bin"
  fi

  # Load Node global installed binaries
  export PATH="$HOME/.node/bin:$PATH"
  # Use project specific binaries before global ones
  # export PATH="node_modules/.bin:vendor/bin:$PATH"

  if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  fi

  if [ -f /usr/local/opt/mysql-client/bin/mysql ]; then
    export PATH="$PATH:/usr/local/opt/mysql-client/bin"
  fi
fi

if [[ -n $LINUX ]]; then
  export PATH="$PATH:~/.local/bin"

  # Snap
  export PATH="$PATH:/snap/bin:/snap/docker/current/bin"
  export GOROOT="/snap/go/current"

  # Homebrew
  export PATH="$PATH:~/.linuxbrew/bin"
fi
