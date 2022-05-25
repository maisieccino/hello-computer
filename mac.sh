#!/bin/bash

# if brew not installed, install it
if ! (which brew>/dev/null); then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	brew update
fi

formulae=(
ag
ctags
doctl
ffmpeg # converting audio files, can skip
fluxctl
fzf
git-lfs
gnupg
golang
htop
hub
istioctl
jq
neovim
nmap
pinentry-mac
pipenv
postgresql
pyenv
ranger
reattach-to-user-namespace
shellcheck
stow
swig
tidy-html5
tmux
wget
z
zmq
zsh-syntax-highlighting
)

casks=(
1password-cli
docker
figma # graphic design, can skip
gimp
google-chrome
insomnia
iterm2
keybase # public key stuff, can skip
ngrok
notion # cloud notes, can skip
spotify
visual-studio-code
vnc-viewer
)

# Needed before you can install the kafka keg.
brew install --cask homebrew/cask-versions/adoptopenjdk8

brew install "${formulae[@]}"
brew install --cask "${casks[@]}"

