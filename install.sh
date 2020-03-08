#!/bin/bash

if (uname | grep -i darwin >/dev/null); then
	./mac.sh
else
	./deb.sh
fi

chsh -s /bin/zsh ${USER}
# oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

./python.sh

# TODO: iTerm dracula theme
# https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors

## Install vim config and extra tools
./vim.sh
# linters

# Node
# nvm install stable
npms=(
	insomnia-importers
	jshint
	jsonlint
	jsxhint
	markdownlint-cli
	raml-cop
	sass-lint
	stylelint
	tern
	write-good
)
sudo npm -g i "${npms[@]}"

# Stow dotfiles
stows=(
	git
	tmux
	vim
	zsh
)


for stow in "${stows[@]}"; do
	stow -v -t ~ "${stow}"
done

