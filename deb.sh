#!/bin/bash

packages=(
	# chromium-codecs-ffmpeg-extra
	curl
	docker.io
	dropbear-initramfs
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
	libbz2-dev
	libffi-dev
	libreadline-dev
	libsqlite3-dev
	libssl-dev
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
	signal-desktop
	silversearcher-ag
	stow
	systemd-coredump
	tailscale
	testdisk
	tmux
	vim-gtk3
	virtualenvwrapper
	vsftpd
	wireshark-gtk
	xclip
	zsh
	zsh-syntax-highlighting
	wireguard
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
	code
	helm
	intellij-idea-community,
	microk8s
)

beta_snaps=(
	kafka
)

# Fetch aptitude keys.
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
curl https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl https://keybase.io/docs/server_security/code_signing_key.asc | sudo apt-key add -
curl 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8cf63ad3f06fc659' | sudo apt-key add -
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -

# Add extra repositories.
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb http://ppa.launchpad.net/jonathonf/vim/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/jonathonf.list
echo "deb http://prerelease.keybase.io/deb stable main" | sudo tee /etc/apt/sources.list.d/keybase.list
curl https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

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

