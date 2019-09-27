#!/bin/bash

# TODO: chsh

# TODO: oh-my-zsh

if (uname | grep -i darwin >/dev/null); then
	./mac.sh
fi

# TODO: virtualenv

# TODO: iTerm dracula theme
# https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors


## Install vim config and extra tools
./vim.sh
# linters
pip3 install --user pycodestyle pyflakes flake8 vim-vint proselint yamllint
# Node
# nvm install stable
npm -g i jshint jsxhint jsonlint stylelint sass-lint raml-cop markdownlint-cli write-good tern

# Stow dotfiles
stows=(
	git
	vim
	zsh
)

for stow in $stows; do
	stow -v -t ~ "${stow}"
done
