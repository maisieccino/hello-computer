bip() {
  local inst=$(brew search "$@" | fzf -m --preview='brew info {}')

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do; brew install $prog; done;
  fi
}

bs() {
    local inst=$(brew search "$@" | fzf --preview='brew info {}')
    if [[ $inst ]]; then
      echo $inst | pbcopy
    fi
}

books() {
  calibredb list --for-machine -f 'all' | jq -r '.[]|[.id,.cover,.title]|@tsv' | fzf \
    --with-nth='{3..}' --accept-nth=1 -d'\t' \
    --preview='~/bin/fzf-preview.sh {2}'\
    --prompt='book: ' \
    --ghost='search title...' | xargs -I {} calibre 'calibre://view-book/books/{}'
}

zgl() {
  git log --oneline $@ | fzf -m --preview='git show --color {1}' \
    --accept-nth='{1}' \
    --prompt="git log: " \
    --ghost="commit id or message..." \
    --footer='CTRL-P: cherry-pick' \
    --bind "ctrl-p:execute(git cherry-pick {+1})"
}

# Git branch
zgb() {
  local res=$(git branch --sort=-HEAD --format='%(refname:short)' $@ |\
    fzf -m --preview='git show --color {r}' \
    --prompt="branches: " \
    --ghost="name..." \
    --footer="ENTER: log, CTRL-O: checkout" \
    --bind "ctrl-o:execute(git checkout {r})+abort")
  if [[ $res ]]; then
    zgl $res
  fi
}

zg() {
  local list =$(read -r -d '' <<EOF
  branch
  log
  sync
EOF
  )

  local res = $(echo ${list} | fzf)
}
