SHELL := /bin/bash

.PHONY: apply push-vault.yml vault.yml edit-vault.yml
apply:
	poetry run ansible-playbook \
		--vault-id 'ansible_vault_pi@vault-pass-client' \
		-i inventory.yml --skip-tags init main.yml

check:
	poetry run ansible-playbook -C \
		--vault-id 'ansible_vault_pi@vault-pass-client' \
		-i inventory.yml --skip-tags init main.yml

edit-vault.yml:
	poetry run ansible-vault edit --vault-id 'ansible_vault_pi@vault-pass-client'

vault.yml:
	pass-cli item view \
		--item-title ansible_vault_pi \
		--field=vault.yml | base64 -d > vault.yml

push-vault.yml:
	pass-cli item update \
		--item-title ansible_vault_pi \
		--field vault.yml=$$(cat vault.yml | base64)
