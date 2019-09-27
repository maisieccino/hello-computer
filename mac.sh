#!/bin/bash

# if brew not installed, install it
if ! (which brew>/dev/null); then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	brew update
fi

formulae=(
ag
awscli
black
ctags
ffmpeg # converting audio files, can skip
fluxctl
fzf
gnupg
golang
htop
hub
istioctl
jq
neovim
pinentry-mac
python
python@2
ranger
salt
shellcheck
sshuttle
stow
tidy-html5
wget
z
)

casks=(
docker
figma # graphic design, can skip
gimp
google-chrome
iterm2
keybase # public key stuff, can skip
notion # cloud notes, can skip
postgres
spotify
telegram-desktop
visual-studio-code
)

brew install "${formulae[@]}"
brew cask install "${casks[@]}"

