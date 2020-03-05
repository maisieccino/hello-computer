#!/bin/bash -x

repo_path="${HOME}/.config/vim"

stat "${repo_path}" >/dev/null
repo_exists=$?
set +e

if [ "$repo_exists" -eq "0" ]; then
	cd "${repo_path}"
	git pull
	make update
	exit 0
else
	git clone https://github.com/rafi/vim-config "${repo_path}"
	ln -s "${repo_path}" ~/.vim
	ln -s "${repo_path}" ~/.config/nvim
	cd "${repo_path}"
	./venv.sh
	make test
	make
fi
