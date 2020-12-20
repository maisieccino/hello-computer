#!/bin/bash -e

###########################################
# This script installs the 1password CLI. #
###########################################


if [ -eq "$(uname)" Linux ]; then
	dir=$(mktemp -d)
	pushd "${dir}"
	op_version="v1.8.0"
	arch=${arch:-amd64}

	curl -Lo op.zip https://cache.agilebits.com/dist/1P/op/pkg/${op_version}/op_linux_${arch}_${op_version}.zip
	unzip op.zip
	gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
	gpg --verify op.sig op
	cp op ~/bin/op
	popd
	rm -r "${dir}"
fi

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
op get document private-key > ~/.ssh/id_rsa
op get document public-key > ~/.ssh/id_rsa.pub
