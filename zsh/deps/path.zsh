#!/usr/bin/env bash

path=($DOTFILES/bin $path $HOME/.local/bin)

if is_macos; then
  path=("/usr/local/sbin" $path)

  if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    path+="/usr/local/opt/coreutils/libexec/gnubin"
  fi

  # Go
  if [ -x "$(command -v go)" ]; then
    export GOROOT="/usr/local/opt/go/libexec"
    export GOPATH="$HOME/go"
  fi
  
  # Ruby
  if [ -d "$HOME/.rubies/ruby-3.1.0/bin" ]; then
    path=("$HOME/.rubies/ruby-3.1.0/bin" $path)
  elif [ -d "/usr/local/opt/ruby/bin" ]; then
    path+="/usr/local/opt/ruby/bin"
  fi

  if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    path+="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  fi

  if [ -f "/usr/local/opt/mysql-client/bin/mysql" ]; then
    path+="/usr/local/opt/mysql-client/bin"
  fi

  if [ -f "/usr/local/opt/libpq/bin" ]; then
    path+="/usr/local/opt/libpq/bin"
  fi
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

# uv
if [ -x "($HOME/.cargo/bin/uv)" ]; then
  path+="$HOME/.cargo/bin"
fi

# Kubernetes - Krew
if [ -d "$HOME/.krew/bin" ]; then
  path=("${KREW_ROOT:-$HOME/.krew}/bin" $path)
fi
