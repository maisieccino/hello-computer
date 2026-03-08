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

# Proton pass
pp() {
  echo "Fetching items..." >&2

  passes=$(
    pass-cli item list --output=json --filter-state=active --sort-by=created-desc |
    jq -r '.items[] | [.id, .content.title] | @tsv'
  )

  res=$(fzf --prompt="Passwords" -d'\t' \
    --with-nth='{2}' --accept-nth='{1}' \
    --preview='pass-cli item view --item-id {1}' <<< "$passes")

  pass-cli item view --item-id "${res}"
}
