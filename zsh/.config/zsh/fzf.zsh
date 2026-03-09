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

save-link() {
  set +x
  local url=${1}
  if [ -z "${url}" ]; then
    echo "You need to add a url!" >&2
    return 1
  fi

  body=$(cat <<EOF
{
  "type": "link",
  "url": "${url}"
}
EOF
)

  curl -H "Authorization: Bearer ${KARAKEEP_SECRET}" \
    -H "Content-Type: application/json" \
    -d "${body}" \
    -XPOST "${KARAKEEP_URL}/api/v1/bookmarks"
}

links() {
  local results=$(curl -H "Authorization: Bearer ${KARAKEEP_SECRET}" \
    -XGET "${KARAKEEP_URL}/api/v1/bookmarks" \
    | jq -r '.bookmarks[] | [.content.title,.id,.content.url, (.assets[] | select(.assetType=="screenshot")|.id) ] | @tsv')


  local preview_cmd="curl -sH \"Authorization: Bearer ${KARAKEEP_SECRET}\" \"${KARAKEEP_URL}/api/v1/assets/{4}\" | kitten icat --clear --transfer-mode=memory"

  local open_cmd="xdg-open"
  if (uname -a | grep -i darwin>/dev/null); then
    open_cmd="open"
  fi

  fzf -d'\t' --with-nth="{1}: {3}" \
    --accept-nth="{3}" \
    --preview-window=up \
    --preview="zsh -c '${preview_cmd}'" <<< "${results}" \
    --footer="ENTER: open, CTRL-O: open in Karakeep" \
    --bind "ctrl-o:execute(${open_cmd} ${KARAKEEP_URL}/dashboard/preview/{2})" |\
      xargs open
}
