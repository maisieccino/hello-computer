#!/bin/bash

# TODO: chsh

# TODO: oh-my-zsh

formulae=(
awscli
neovim
golang
python@2
python
wget
hub
gnupg
pinentry-mac
salt
black
shellcheck
tidy-html5
ag
z
ctags
fzf
)

casks=(
visual-studio-code
docker
telegram-desktop
iterm2
keybase
spotify
notion
figma
)

brew install "${formulae[@]}"
brew cask install "${casks[@]}"

# TODO: virtualenv
# TODO: install `black` linter

# TODO: iTerm dracula theme
# https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors

# TODO: vim-config
# https://github.com/rafi/vim-config
# linters
pip3 install --user pycodestyle pyflakes flake8 vim-vint proselint yamllint

# Node
nvm install stable
npm -g i jshint jsxhint jsonlint stylelint sass-lint raml-cop markdownlint-cli write-good tern

