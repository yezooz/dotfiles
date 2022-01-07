# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
# ZSH_CUSTOM="$DOTFILES/zsh"

source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh

# https://github.com/marlonrichert/zsh-autocomplete/blob/main/.zshrc
zstyle ':autocomplete:*' min-input 1
source $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="spaceship"
# ZSH_THEME="pure"

DEFAULT_USER="marek"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
UPDATE_ZSH_DAYS=1

DISABLE_UPDATE_PROMPT="true"

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

# Autoupdate plugin
ZSH_CUSTOM_AUTOUPDATE_QUIET="true"

# Colorize plugin
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colorize
ZSH_COLORIZE_TOOL="chroma"
# ZSH_COLORIZE_STYLE="colorful"
ZSH_COLORIZE_CHROMA_FORMATTER="terminal256"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(z sudo git aws aliases extract colorize python golang poetry terraform docker docker-compose)
# plugins=(autoupdate command-not-found sudo aliases extract colorize colored-man-pages cp git python zsh-nvm)
plugins=(autoupdate command-not-found sudo git aliases extract colorize cp python)

# --- User configuration ---

source $HOME/.pre.zsh

source $ZSH/oh-my-zsh.sh

# Load the shell dotfiles, and then some:
for file in ~/.{path,exports,aliases,functions,autocomplete}; do
  file="$file.zsh"
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

[[ -n $MACOS && -f ~/.macos.zsh ]] && source ~/.macos.zsh
[[ -n $LINUX && -f ~/.linux.zsh ]] && source ~/.linux.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Starship
# export STARSHIP_CONFIG="$HOME/.starship/config.toml"
# eval "$(starship init zsh)"
# function set_win_title(){
#     echo -ne "\033]0; $(basename "$PWD") \007"
# }
# starship_precmd_user_func="set_win_title"

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