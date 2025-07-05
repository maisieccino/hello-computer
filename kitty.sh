#!/bin/bash

curl -o ~/.config/kitty/dracula.conf https://raw.githubusercontent.com/dracula/kitty/refs/heads/master/dracula.conf
curl -o ~/.config/kitty/diff.conf https://raw.githubusercontent.com/dracula/kitty/refs/heads/master/diff.conf

echo "include dracula.conf" >>~/.config/kitty/kitty.conf
