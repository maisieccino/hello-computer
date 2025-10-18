###
### OPTS
###
unsetopt AUTO_CD # Disable automatic directory changing without calling cd.
setopt SHARE_HISTORY
HISTFILE=~/.zsh_history
bindkey -e

export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${HOME}/.local/bin"

export XDG_CONFIG_HOME="${HOME}/.config"

if (uname -a | grep -i darwin >/dev/null); then
  # For M1 Macs
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
else
  export PATH="/opt/brew/bin:/opt/brew/sbin:$PATH"
fi

# PyEnv
if (stat "${HOME}/.pyenv/bin" >/dev/null 2>/dev/null); then
  export PATH="${HOME}/.pyenv/bin:${PATH}"
fi
if (stat "${HOME}/.pyenv/shims" >/dev/null 2>/dev/null); then
  export PATH="${HOME}/.pyenv/shims:${PATH}"
fi
if (which pyenv >/dev/null 2>/dev/null); then
  eval "$(pyenv init -)"
fi

if (uname -a | grep -i darwin>/dev/null); then
  [[ -d $(brew --prefix)/share/zsh/site-functions/ ]] && fpath+=($(brew --prefix)/share/zsh/site-functions/)
fi
export EDITOR=nvim

if (command -v fnm &>/dev/null)
then
  # FNM is a faster version of NVM.
  alias nvm="fnm"
  eval "$(fnm --version-file-strategy=recursive --log-level=quiet env --use-on-cd)"
else
  # NVM
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  check_nvm() {
    if [ -f ".nvmrc" ]; then
      nvm use
    fi
  }
  autoload -U add-zsh-hook
  add-zsh-hook chpwd check_nvm
  check_nvm
fi

# GnuPG
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon 2>/dev/null)
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

if (uname -a | grep -i darwin >/dev/null); then
    [ -f $(brew --prefix)/opt/fzf/shell/key-bindings.zsh ] && source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
    [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ] && source $(brew --prefix)/opt/fzf/shell/completion.zsh
fi

# Go
export GOPATH=$HOME/go
export GOPRIVATE="*.apple.com"
export PATH=$GOPATH/bin:$PATH

# Secrets.
[ -f ~/.secrets ] && source ~/.secrets

# Custom functions
source $HOME/.config/zsh/functions.zsh


# syntax highlighting
if (uname -a | grep -i darwin >/dev/null); then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# history substring search
# Options: https://github.com/zsh-users/zsh-history-substring-search#configuration
HISTORY_SUBSTRING_SEARCH_PREFIXED='yes' # Use the prefix to search.
if (uname -a | grep -i darwin >/dev/null); then
  source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
else
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey "^[[A" history-substring-search-up
  bindkey "^[[B" history-substring-search-down
fi
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[b" backward-word
bindkey "^[f" forward-word

fpath=(/usr/local/share/zsh-completions $fpath)

# rbenv
if which rbenv >/dev/null; then
  eval "$(rbenv init -)"
fi

# Activate Mise
if (which mise >/dev/null); then
  eval "$(mise activate zsh)"
fi

if [ -d ~/src/github.com/monzo ]; then
  source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
  source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
  export CLOUDSDK_PYTHON=/Users/maisiebell/.pyenv/versions/3.9.10/bin/python
  export OAUTHLIB_RELAX_TOKEN_SCOPE=1
  source /Users/maisiebell/src/github.com/monzo/analytics/dbt/misc/shell/source.sh
fi
export TFENV_ARCH=amd64

eval "$(zoxide init zsh)"

# Carapace shell completion
if (which carapace >/dev/null) then
  autoload -Uz compinit
  compinit
  export CARAPACE_BRIDGES='cobra,kitten,zsh'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

eval "$(starship init zsh)"
