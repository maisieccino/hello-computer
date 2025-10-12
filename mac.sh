#!/bin/bash

# if brew not installed, install it
if ! (which brew >/dev/null); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

stow -v -t ~ -S homebrew
brew bundle --global install
