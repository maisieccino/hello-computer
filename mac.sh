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
ffmpeg # converting audio files, can skip
ranger
)

casks=(
visual-studio-code
docker
telegram-desktop
iterm2
keybase # public key stuff, can skip
spotify
notion # cloud notes, can skip
figma # graphic design, can skip
postgres
google-chrome
)

brew install "${formulae[@]}"
brew cask install "${casks[@]}"

