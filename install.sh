#!/bin/bash

if (uname -a | grep -i -e ubuntu -e debian >/dev/null); then
	./deb.sh
elif (uname | grep -i darwin >/dev/null); then
	./mac.sh
fi

chsh -s /bin/zsh ${USER}
# oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# TODO: virtualenv

# TODO: iTerm dracula theme
# https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors


## Install vim config and extra tools
./vim.sh
# linters
pip3 install --user pycodestyle pyflakes flake8 vim-vint proselint yamllint

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
	vim
	zsh
)

for stow in "${stows[@]}"; do
	stow -v -t ~ "${stow}"
done
