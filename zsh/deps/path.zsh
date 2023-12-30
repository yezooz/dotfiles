#!/usr/bin/env bash

path=($DOTFILES/bin $path $HOME/.local/bin)

if is_macos; then
  path=("/usr/local/sbin" $path)

  # Python 3.12
  if [ -d "/usr/local/opt/python@3.12/libexec/bin" ]; then
    path=("/usr/local/opt/python@3.12/libexec/bin" $path)
  elif [ -d "/usr/local/opt/python@3.11/bin" ]; then
    path=("/usr/local/opt/python@3.11/bin" $path)
  elif [ -d "/usr/local/opt/python@3.10/bin" ]; then
    path=("/usr/local/opt/python@3.10/bin" $path)
  fi

  # Node 18
  if [ -d "/usr/local/opt/node@18/bin" ]; then
    path=("/usr/local/opt/node@18/bin" $path)
  fi

  if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    path+="/usr/local/opt/coreutils/libexec/gnubin"
  fi

  # Go
  if [ -x "$(command -v go)" ]; then
    export GOROOT="/usr/local/opt/go/libexec"
    export GOPATH="$HOME/go"
  fi
  
  # Dotnet
  if [ -x "$(command -v dotnet)" ]; then
    export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
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

# Pipx
# if [ -x "$(command -v pipx)" ]; then
#   path+="$HOME/.local/bin"
# fi