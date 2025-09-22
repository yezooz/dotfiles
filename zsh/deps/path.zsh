#!/usr/bin/env bash

path=($DOTFILES/bin $path $HOME/.local/bin)

if is_macos; then
  p=("/usr/local/sbin")

  if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    p+="/usr/local/opt/coreutils/libexec/gnubin"
  fi

  # Go
  if [ -x "$(command -v go)" ]; then
    export GOROOT="/usr/local/opt/go/libexec"
    export GOPATH="$HOME/go"
  fi
  
  # Node
  if [ -d "/usr/local/opt/node@20/bin" ]; then
    p+="/usr/local/opt/node@20/bin"
  fi
  
  # Ruby
  if [ -d "/usr/local/opt/ruby/bin" ]; then
    p+="/usr/local/opt/ruby/bin"
  fi

  if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    p+="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  fi

  if [ -f "/usr/local/opt/mysql-client/bin/mysql" ]; then
    p+="/usr/local/opt/mysql-client/bin"
  fi
  
  if [ -f "/usr/local/opt/sqlite/bin/sqlite3" ]; then
    p+="/usr/local/opt/sqlite/bin"
  fi

  if [ -f "/usr/local/opt/libpq/bin" ]; then
    p+="/usr/local/opt/libpq/bin"
  fi

  path=($p $path)
fi

if is_linux; then
  # Snap
  export GOROOT="/snap/go/current"
  export GOPATH="$HOME/go"

  path=($path "/snap/bin" "/snap/docker/current/bin")

  # Homebrew
  path+="$HOME/.linuxbrew/bin"
fi

# Go
if [ -x "$(command -v go)" ]; then
  [[ -d $GOROOT/bin ]] && path+="$GOROOT/bin"
  [[ -d $GOPATH/bin ]] && path+="$GOPATH/bin"
fi

# Rust
if [ -x "$(command -v cargo)" ]; then
  path+="$HOME/.cargo/bin"
fi

# Composer
if [ -x "$(command -v composer)" ]; then
  path+="$HOME/.composer/vendor/bin"
fi

# Nodejs
path+="$HOME/.node/bin"
# Use project specific binaries before global ones
# path=(node_modules/.bin vendor/bin $path)

# Kubernetes - Krew
if [ -d "$HOME/.krew/bin" ]; then
  path=("${KREW_ROOT:-$HOME/.krew}/bin" $path)
fi
