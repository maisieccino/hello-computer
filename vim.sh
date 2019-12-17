#!/bin/bash

repo_path="${HOME}/.config/vim"

stat "${repo_path}" >/dev/null
repo_exists=$?

if [ "$repo_exists" -eq "0" ]; then
	cd "${repo_path}"
	git pull
	make update
	exit 0
else
	git clone https://github.com/rafi/vim-config "${repo_path}"
	ln -s "${repo_path}" ~/.vim
	cd "${repo_path}"
	pip3 install pynvim
	make test
	make
fi
