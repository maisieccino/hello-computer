#!/bin/bash

if (uname | grep -i darwin >/dev/null); then
  ./mac.sh
else
  ./deb.sh
fi

chsh -s /bin/zsh ${USER}

./python.sh

# Golang-specific stuff.
./go.sh

# Install vim config and extra tools
./vim.sh

# Fetch secrets.
if [ -z "${SKIP_OP}" ]; then
  ./op.sh
fi

# Stow dotfiles
stows=(
  git
  kitty
  starship
  tmux
  vim
  zsh
)

for stow in "${stows[@]}"; do
  stow -v -t ~ "${stow}"
done
