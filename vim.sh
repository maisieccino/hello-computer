#!/bin/bash -x

repo_path="${HOME}/.config/vim"

stat "${repo_path}" >/dev/null
repo_exists=$?
set +e

if [ "$repo_exists" -eq "0" ]; then
	pushd "${repo_path}"
	git pull
	make update
	popd
else
	git clone https://github.com/rafi/vim-config "${repo_path}"
	ln -s "${repo_path}" ~/.vim
	ln -s "${repo_path}" ~/.config/nvim
	pushd "${repo_path}"
	./venv.sh
	make test
	make
	popd
fi

# vim -V1 -es -i NONE -N -u config/init.vim -c "try | exe ':GoInstallBinaries' | finally | qall\! | endtry"
cp ./local.plugins.yaml "${HOME}/.config/vim/config"
cp ./local.vim "${HOME}/.config/vim/config"

work_repo_path="${HOME}/work/hello-computer"
stat "${work_repo_path}" >/dev/null
work_repo_exists=$?
if [ "${work_repo_exists}" -eq "0" ]; then
	cat "${work_repo_path}/local.work.vim" >> ${repo_path}/config/local.vim
	cat "${work_repo_path}/local.work.yaml" >> ${repo_path}/config/local.plugins.yaml
fi
