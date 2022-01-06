#!/usr/bin/env bash

if [[ -n $MACOS ]]; then
  path=("$HOME/.local/bin" "/usr/local/sbin" $path)

  # Go
  if [ -x "$(command -v go)" ]; then
    export GOROOT="/usr/local/opt/go/libexec"
    export GOPATH="$HOME/go"
  fi

  if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    path+="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  fi

  if [ -f "/usr/local/opt/mysql-client/bin/mysql" ]; then
    path+="/usr/local/opt/mysql-client/bin"
  fi
elif [[ -n $LINUX ]]; then
  path+="$HOME/.local/bin"

  # Snap
  export GOROOT="/snap/go/current"
  export GOPATH="$HOME/go"

  path=($path "/snap/bin" "/snap/docker/current/bin")

  # Homebrew
  # export PATH="$PATH:~/.linuxbrew/bin"
  path+="$HOME/.linuxbrew/bin"
fi

# Go
# if [ -x "$(command -v go)" ]; then
#   path+="$GOROOT/bin"
#   path+="$GOPATH/bin"
# fi

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
