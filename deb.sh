#!/bin/bash

packages=(
	chromium-browser
	chromium-codecs-ffmpeg-extra
	curl
	fzf
	gnome-tweak-tool
	gnupg
	htop
	hub
	nodejs
	npm
	python
	python-pip
	python-virtualenv
	python-wheel
	python3
	python3-pip
	python3-virtualenv
	python3-wheel
	silversearcher-ag
	stow
	telegram-desktop
	vim
	virtualenvwrapper
	wget
	zsh
	zsh-syntax-highlighting
)

snaps=(
	opera
	spotify
)

classic_snaps=(
	microk8s
)

sudo apt install -y "${packages[@]}"

if (which snap >/dev/null); then
	for snap in "${snaps[@]}"; do
		sudo snap install "${snap}"
	done
	for snap in "${classic_snaps[@]}"; do
		sudo snap install --classic "${snap}"
	done
fi

