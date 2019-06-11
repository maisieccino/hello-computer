#!/bin/bash

# TODO: chsh

# TODO: oh-my-zsh

is_darwin=$(uname | grep -i darwin)
if [ -n "$is_darwin" ]; then
	./mac.sh
fi

# TODO: virtualenv
# TODO: install `black` linter

# TODO: iTerm dracula theme
# https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors

# TODO: vim-config
# https://github.com/rafi/vim-config
# linters
pip3 install --user pycodestyle pyflakes flake8 vim-vint proselint yamllint

# Node
# nvm install stable
npm -g i jshint jsxhint jsonlint stylelint sass-lint raml-cop markdownlint-cli write-good tern

