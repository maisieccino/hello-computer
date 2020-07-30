#!/bin/bash

packages=(
	# chromium-codecs-ffmpeg-extra
	curl
	docker.io
	fonts-noto-color-emoji
	fzf
	gimp
	gnome-sushi
	gnome-tweak-tool
	gnupg
	golang
	heif-thumbnailer
	htop
	hub
	ifuse
	jq
	kubectl
	libffi-dev
	make
	mpv
	neofetch
	net-tools
	nodejs
	nmap
	npm
	openshot
	openssh-server
	postgresql-client
	psensor
	python3
	python3-pip
	python3-virtualenv
	python3-wheel
	ranger
	silversearcher-ag
	stow
	systemd-coredump
	testdisk
	tmux
	vim-gtk3
	virtualenvwrapper
	vsftpd
	wireshark-gtk
	xclip
	zsh
	zsh-syntax-highlighting
)

snaps=(
	chromium
	discord
	doctl
	opera
	spotify
	telegram-desktop
)

classic_snaps=(
	helm
	intellij-idea-community,
	microk8s
)

beta_snaps=(
	kafka
)

# Fetch aptitude keys.
wget -q -O- https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

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
	for snap in "${beta_snaps[@]}"; do
		sudo snap install --beta "${snap}"
	done
fi

