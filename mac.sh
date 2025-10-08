#!/bin/bash

# if brew not installed, install it
if ! (which brew >/dev/null); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

formulae=(
  ag
  bat
  doctl
  ffmpeg
  fzf
  git-lfs
  gnupg
  golang
  htop
  hub
  jq
  lazygit
  neovim
  nmap
  pinentry-mac
  postgresql@15
  pyenv
  ranger
  reattach-to-user-namespace
  shellcheck
  stow
  tidy-html5
  tmux
  wget
  zoxide
  zsh-syntax-highlighting
)

casks=(
  1password-cli
  # docker Deprecated, use `container` in macOS Tahoe
  figma # graphic design, can skip
  iterm2
  keybase # public key stuff, can skip
)

# Needed before you can install the kafka keg.
brew install --cask homebrew/cask-versions/adoptopenjdk8

brew install "${formulae[@]}"
brew install --cask "${casks[@]}"
