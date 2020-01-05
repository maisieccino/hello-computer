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
httpie
htop
hub
istioctl
jq
kafka
neovim
nmap
pinentry-mac
pipenv
python
python@2
ranger
salt
shellcheck
sshuttle
stow
tidy-html5
tmux
wget
z
)

casks=(
docker
figma # graphic design, can skip
gimp
goland # optional, golang editor
google-chrome
insomnia
iterm2
keybase # public key stuff, can skip
ngrok
notion # cloud notes, can skip
postgres
spotify
telegram-desktop
visual-studio-code
vnc-viewer
wireshark
)

# Needed before you can install the kafka keg.
brew cask install homebrew/cask-versions/adoptopenjdk8

brew install "${formulae[@]}"
brew cask install "${casks[@]}"

