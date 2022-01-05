# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"

DEFAULT_USER="marek"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Colorize plugin
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colorize
ZSH_COLORIZE_TOOL=chroma
# ZSH_COLORIZE_STYLE="colorful"
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(z sudo git aws common-aliases aliases extract colorize python golang poetry terraform docker docker-compose)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/dsa_id"

# OS Detection
if [[ $(uname) == "Darwin" ]]; then
  export OSX=1
elif [[ $(uname) == "Linux" ]]; then
  export LINUX=1
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
source $HOME/.zsh_aliases

# Linux
if [[ -n $LINUX ]]; then
  export GNU_USERLAND=1
  export EDITOR="vim"
  export TERMINAL="terminator"

  export PATH="$PATH:~/.local/bin"

  # Snap
  export PATH="$PATH:/snap/bin:/snap/docker/current/bin"
  export GOROOT="/snap/go/current"

  # Homebrew
  export PATH="$PATH:~/.linuxbrew/bin"

  # Caps Lock as ESC for Vim
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
fi

# macOS
if [[ -n $OSX ]]; then

  # Preferred editor for local and remote sessions
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="vim"
  else
    export EDITOR="subl -w"
  fi

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

  # pipx
  if [ -x "$(command -v pipx)" ]; then
    # export PATH="$PATH:$HOME/.local/bin"
    eval "$(register-python-argcomplete pipx)"
  fi
  
  # Composer
  if [ -x "$(command -v composer)" ]; then
    export PATH="$PATH:$HOME/.composer/vendor/bin"
  fi

  if [ -x "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
  fi

  if [ -x "$(command -v vault)" ]; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /usr/local/bin/vault vault
  fi
  
  if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  fi

  if [ -f /usr/local/opt/mysql-client/bin/mysql ]; then
    export PATH="$PATH:/usr/local/opt/mysql-client/bin"
  fi

  test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

  # Direnv
  export DIRENV_LOG_FORMAT=""
  eval "$(direnv hook zsh)"
fi

# Search
fpath+=~/.zfunc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<