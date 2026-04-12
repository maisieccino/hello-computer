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
  FZF_EXEC="${FZF_EXEC:-fzf}"

  if [ -n "$1" ]; then
    _matching_filter="[.items[] | select(.content.content.Login.urls | any(.[]; contains(\"${1}\")))]"
  echo "Fetching items for '${1}'..." >&2
  else
    _matching_filter="[.items[]]"
    echo "Fetching items..." >&2
  fi

  _passes=$(
    pass-cli item list \
      --filter-type=login \
      --output=json \
      --filter-state=active \
      --sort-by=created-desc
  )

  _matching=$(jq "${_matching_filter}" <<< "${_passes}")

  if [[ $(jq length <<< "${_matching}") -eq "1" ]]; then
    res=$(jq '.[0].id' <<< "${_matching}")
    pass-cli item view --item-id "${res}" --output=json
    return 0
  elif [[ $(jq length <<< "${_matching}") -ne "0" ]]; then
    _passes="${_matching}"
  else
    _passes=$(jq '[.items[]]' <<< "${_passes}")
  fi

  _items=$(jq -r '.[] | [.id, .content.title, .content.content.Login.totp_uri // ""] | @tsv' <<< "${_passes}")

  _preview_filter=$(cat <<EOF
"## " + .item.content.title
+ "\n\n"
+ "Username: " + .item.content.content.Login.username + "\n\n"
+ "Email: " + .item.content.content.Login.email + "\n\n"
+ "Created at: " + .item.create_time + "\n\n"
+ "Modified at: " + .item.modify_time + "\n\n"
+ "### URLs\n\n" + ([.item.content.content.Login.urls[] | "- " + . ] | join("\n"))
EOF
)
  _preview_script="CLICOLOR_FORCE=1 pass-cli item view --item-id {1} --output=json | jq -r '${_preview_filter}' | glow"

  # res=$(${FZF_EXEC} --prompt="Passwords" -d'\t' \
  #   --with-nth='{2}' --accept-nth='{1}' \
  #   --preview="CLICOLOR_FORCE=1 pass-cli item view --item-id {1} --output=json | jq -r '${_preview_filter}' | glow" \
  #   <<< "$_items")
  res=$(${FZF_EXEC} --prompt="Passwords " -d'\t' \
    --with-nth='{2}' --accept-nth='{1}' \
    --preview='pass-cli item view --item-id={1}' \
    --footer="ENTER: select, CTRL-T: Copy OTP" \
    --bind "ctrl-T:execute(pass-cli totp generate {3} | wl-copy)" \
    <<< "$_items")

  if [ $? -ne 0 ] || [ -z "${res}" ]; then
    echo "Nothing selected" >&2
    return 1
  fi

  pass-cli item view --item-id "${res}" --output=json
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
  if [ -z "${KARAKEEP_SECRET}"]; then
    echo "KARAKEEP_SECRET is missing!" >&2
    return 1
  fi
  if [ -z "${KARAKEEP_URL}"]; then
    echo "KARAKEEP_URL is missing!" >&2
    return 1
  fi

  local results=$(curl -H "Authorization: Bearer ${KARAKEEP_SECRET}" \
    -XGET "${KARAKEEP_URL}/api/v1/bookmarks" \
    | jq -r '.bookmarks[] | [.content.title,.id,.content.url, (.assets[] | select(.assetType=="screenshot")|.id) ] | @tsv')


  local build_preview_cmd() {
    local curl_cmd="curl -sH \"Authorization: Bearer ${KARAKEEP_SECRET}\" \"${KARAKEEP_URL}/api/v1/assets/{4}\""
    local icat_cmd="kitten icat --clear --transfer-mode=memory --place=\"\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0\""
    echo "${curl_cmd} | ${icat_cmd}"
  }
  local preview_cmd="$(build_preview_cmd)"

  local open_cmd="xdg-open"
  if (uname -a | grep -i darwin>/dev/null); then
    open_cmd="open"
  fi

  result=$(fzf -d'\t' --with-nth="{1}: {3}" \
    --accept-nth="{3}" \
    --preview="zsh -c '${preview_cmd}'" <<< "${results}" \
    --footer="ENTER: open, CTRL-O: open in Karakeep" \
    --bind "ctrl-o:execute(${open_cmd} ${KARAKEEP_URL}/dashboard/preview/{2})")

  if [ $? -ne 0 ]; then
    return
  fi
  $open_cmd "${result}"
}
