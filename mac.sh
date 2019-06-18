#!/bin/bash

formulae=(
awscli
neovim
golang
python
python@2
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
ffmpeg
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
postgres
google-chrome
)

brew install "${formulae[@]}"
brew cask install "${casks[@]}"

