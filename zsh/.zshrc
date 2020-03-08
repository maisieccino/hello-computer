# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

export PATH="${PATH}:${HOME}/bin"

# ZSH_THEME="lambda"
PROMPT='λ '
if (stat "${HOME}/.remote" >/dev/null 2>/dev/null); then
	PROMPT="${HOST} λ "
fi

COMPLETION_WAITING_DOTS="true"

# PyEnv
if (stat "${HOME}/.pyenv/bin" >/dev/null 2>/dev/null); then
  export PATH="${HOME}/.pyenv/bin:${PATH}"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

plugins=(
# aws - aws-cli package sorts this for us.
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

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# virtualenv
export WORKON_HOME=$HOME/venvs
if (uname -a | grep -i darwin >/dev/null); then
else
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

# GitHub CLI
alias git=hub

# GnuPG
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon 2>/dev/null)
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Go
export GOPATH=$HOME/go
export GOPRIVATE="github.com/limejump"
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
export FLUX_FORWARD_NAMESPACE="flux"

# secrets
source ~/.secrets

# Generates a checksum for a given directory. Useful for checking for Helm chart
# regressions.
function checksum_dir {
    find "${1}" -type f | xargs cat | sha256sum | cut -d' ' -f1
}

# syntax highlighting
if (uname -a | grep -i darwin >/dev/null); then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

fpath=(/usr/local/share/zsh-completions $fpath)

function authorizeme () {
  prod_group_id=sg-c8e2fdad
  preprod_group_id=sg-a93173cc
  description="Matt Remote $(date +%F)"
  my_ip=$(curl -s 'https://api.ipify.org?format=json' \
    | python -c "import sys, json; print(json.load(sys.stdin)['ip'])")/32
 
  aws ec2 authorize-security-group-ingress \
    --group-id $preprod_group_id \
    --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$my_ip,Description=$description}]"
      aws ec2 authorize-security-group-ingress \
        --group-id $prod_group_id \
        --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$my_ip,Description=$description}]"
}
