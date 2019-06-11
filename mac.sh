#!/bin/bash

formulae=(
awscli
neovim
golang
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
sshuttle
ranger
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

