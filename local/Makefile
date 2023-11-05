
.DEFAULT_GOAL := help

init: ;@ ## Initialize workspace
	terraform -chdir="saas" init
.PHONY: init

plan: ;@ ## Perform dry run
	terraform -chdir="saas" plan
.PHONY: plan

apply: ;@ ## Build infrastructure
	terraform -chdir="saas" apply

	@M2M_POOL_ID=$(shell terraform -chdir="saas" output -raw shared_user_pool_id); \
	M2M_USER="M2M-admin-client-application"; \
	M2M_PASSWORD=$(shell openssl rand -hex 16); \
	cd ..; ./scripts/create-m2m-clients.sh "$$M2M_POOL_ID" "$$M2M_USER" "P$$M2M_PASSWORD!"
.PHONY: apply

destroy: ;@ ## Destroy infrastructure
	@echo "WARNING! Destroying local environment infrastructure..."
	terraform -chdir="saas" destroy
.PHONY: destroy

help:
	@echo
	@echo "- Setup Instructions -"
	@echo
	@echo 1. make init
	@echo 2. make plan
	@echo 3. make apply
	@echo
	@grep -hE '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: help