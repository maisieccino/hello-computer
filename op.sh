#!/bin/bash -e

###########################################
# This script installs the 1password CLI. #
###########################################

op_version="v0.10.0"

dir=$(mktemp -d)
pushd "${dir}"

curl -Lo op.zip https://cache.agilebits.com/dist/1P/op/pkg/${op_version}/op_linux_amd64_${op_version}.zip
unzip op.zip
gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
gpg --verify op.sig op
cp op ~/bin/op

# Get email
echo "1Password account email?"
read -r email

# Set up/authenticate with 1password.
if [ ! -f ~/.op/config ]; then
	eval $(op signin my.1password.com "${email}")
else
	existing_account=$(jq ".accounts[] | select(.email == \"${email}\")" ~/.op/config)
	if [ "${existing_account}" == "" ]; then
		eval $(op signin my.1password.com "${email}")
	else
		eval $(op signin)
	fi
fi

# Fetch files.
op get private-key > ~/.ssh/id_rsa
op get public-key > ~/.ssh/id_rsa.pub

popd
rm -r "${dir}"
