#!/bin/bash

packages=(
	chromium-codecs-ffmpeg-extra
	curl
	docker.io
	fzf
	gnome-sushi
	gnome-tweak-tool
	gnupg
	golang
	htop
	hub
	jq
	kubectl
	libffi-dev
	nodejs
	nmap
	npm
	python3
	python3-pip
	python3-virtualenv
	python3-wheel
	silversearcher-ag
	stow
	telegram-desktop
	tmux
	vim
	virtualenvwrapper
	vsftpd
	wget
	xclip
	zsh
	zsh-syntax-highlighting
)

snaps=(
	chromium
	doctl
	opera
	spotify
)

classic_snaps=(
	microk8s
)

# Fetch aptitude keys.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add extra repositories.
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb http://ppa.launchpad.net/jonathonf/vim/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/jonathonf.list
echo "deb http://prerelease.keybase.io/deb stable main" | sudo tee /etc/apt/sources.list.d/keybase.list

sudo apt update
sudo apt install -y "${packages[@]}"

if (which snap >/dev/null); then
	for snap in "${snaps[@]}"; do
		sudo snap install "${snap}"
	done
	for snap in "${classic_snaps[@]}"; do
		sudo snap install --classic "${snap}"
	done
fi

