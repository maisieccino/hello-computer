#!/bin/bash -xe

PYTHON_LATEST="3.8.2"
PYTHON2_LATEST="2.7.6"

pyenv install -s "${PYTHON_LATEST}"
pyenv install -s "${PYTHON2_LATEST}"
pyenv global "${PYTHON_LATEST}" "${PYTHON2_LATEST}"

pips=(
	PyYAML
	awscli
	black
	flake8
	httpie
	proselint
	pycodestyle
	pyflakes
	pynvim
	sshuttle
	vim-vint
	watchman
	yamllint
)

for pkg in "${pips[@]}"; do
	pip install ${pkg}
done

# PYTHON_35_VERSION="3.5.6"
# 
# pyenv install -s "${PYTHON_35_VERSION}"
# 
# pip35s=(
# 	salt
# )
# 
# export PYENV_VERSION=${PYTHON_35_VERSION}
# eval "$(pyenv init -)"
# pyenv shell ${PYTHON_35_VERSION}
# for pkg in "${pip35s[@]}"; do
# 	pip install ${pkg}
# done
# unset PYENV_VERSION
