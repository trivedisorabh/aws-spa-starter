.PHONY: validate deploy

fmt:
	terraform fmt -recursive

deploy: validate
	terraform apply

validate: fmt
	terraform validate



