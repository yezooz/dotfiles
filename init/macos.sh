#!/usr/bin/env bash

function backup_and_link() {
	[[ -L ~/.$1 ]] && unlink ~/.$1 && echo "unlink ~/.$1"
	[[ -f ~/.$1 ]] && mv ~/.$1 ~/.$1.old 2>/dev/null && echo "mv ~/.$1 ~/.$1.old"
	ln -s $DOTFILES/$2/$1 ~/.$1 && echo "ln -s $DOTFILES/$2/$1 ~/.$1"
}

function add_path() {
	[[ :$PATH: == *:$1:* ]] || export PATH="$1:$PATH"
	echo "updated PATH: $PATH"
}

DOTFILES=~/.dotfiles
if [[ ! -d $DOTFILES ]]; then
	git clone https://github.com/yezooz/dotfiles.git $DOTFILES
fi

# Homebrew
if [[ ! "$(type -P brew)" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# brew install git openssh fzf tree openssl python cmake wget freetype htop
# brew --cask install iterm2 xquartz

# Zsh
if [[ ! "$(type -P zsh)" ]]; then
    brew install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

	git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
	git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
	git clone https://github.com/olets/zsh-window-title.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-window-title
	# git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
fi

# Zsh extensions
[[ ! -L ~/.zshrc ]] && ln -s $DOTFILES/zsh/zshrc ~/.zshrc
[[ ! -L ~/.p10k.zsh ]] && ln -s $DOTFILES/zsh/p10k.zsh ~/.p10k.zsh

brew install exa chroma
brew install docker-completion docker-compose docker-compose-completion

# https://github.com/ryanoasis/nerd-fonts
# cd ~/Library/Fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

# dotfiles directory
# dotfiledir=${homedir}/dotfiles

# list of files/folders to symlink in ${homedir}
# files="bash_profile bashrc bash_prompt aliases private"

# change to the dotfiles directory
# echo "Changing to the ${dotfiledir} directory"
# cd ${dotfiledir}
# echo "...done"

# create symlinks (will overwrite old dotfiles)
# for file in ${files}; do
#     echo "Creating symlink to $file in home directory."
#     ln -sf ${dotfiledir}/.${file} ${homedir}/.${file}
# done

# Vim
# if [[ ! "$(type -P vim)" ]]; then
# 	brew install vim
# 	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# 	pip3 install pynvim
# 	mv ~/.vimrc ~/.vimrc.old 2>/dev/null
# 	ln -s ~/dotfiles/vimrc ~/.vimrc
# 	ln -s ~/dotfiles/vim/colors ~/.vim/colors
# fi

# Ruby
# if [[ ! "$(type -P ruby)" ]]; then
# 	brew install ruby-install
# 	ruby-install ruby-3.1.0 \
# 	--no-install-deps \
# 	-- \
# 	--without-X11 \
# 	--without-tk \
# 	--enable-shared \
# 	--disable-install-doc \
# 	--with-openssl-dir="$(brew --prefix openssl)"
# fi

# Git
[[ ! -L ~/.gitconfig ]] && ln -s $DOTFILES/git/gitconfig ~/.gitconfig
[[ ! -L ~/.gitignore ]] && ln -s $DOTFILES/git/gitignore ~/.gitignore
[[ ! -L ~/.git_template ]] && ln -s $DOTFILES/git/git_template ~/.git_template
