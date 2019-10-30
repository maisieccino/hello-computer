# Path to your oh-my-zsh installation.
export ZSH="/Users/matt/.oh-my-zsh"

export PATH="${PATH}:${HOME}/bin"

# ZSH_THEME="lambda"
PROMPT="λ "

COMPLETION_WAITING_DOTS="true"

plugins=(
# aws
django
docker
helm
git
go
kubectl
osx
pip
salt
# virtualenvwrapper
)

source $ZSH/oh-my-zsh.sh

export EDITOR=vim

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# virtualenv
export WORKON_HOME=$HOME/venvs
export PATH=$PATH:/Users/matt/Library/Python/3.7/bin
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

# GitHub CLI
alias git=hub

# GnuPG
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon)
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

####################
# CUSTOM FUNCTIONS #
####################

# mkcd recursively creates and cds into a directory
function mkcd() {
    mkdir -p $1
    cd $1
}


# Elevates the last run command using sudo
function elevate_last_command() {
    # Check if running with ZSH history verification
    if [ -z ${HIST_VERIFY+x} ]; then
        setopt no_histverify
        sudo `fc -ln -1`
        setopt histverify
    else
        sudo `fc -ln -1`
    fi
}

# fuck I forgot to sudo
alias fuck=elevate_last_command

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

function latest_tag {
    echo "latest tag: $(git tag -l | sort -r --version-sort | head -n1)"
}

function docker_size {
    docker image inspect "${1}" | jq '.[0].Size' | numfmt --to=iec-i --suffix=B
}

# Set the current context's namespace.
function kube_ns() {
    kubectl config set-context --current --namespace "${1}"
}

# secrets
source ~/.secrets

# Generates a checksum for a given directory. Useful for checking for Helm chart
# regressions.
function checksum_dir {
    find "${1}" -type f | xargs cat | sha256sum | cut -d' ' -f1
}
