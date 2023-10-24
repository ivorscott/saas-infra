
.DEFAULT_GOAL := help

init: ;@ ## Initialize workspace
	terraform -chdir="func" init
	terraform -chdir="saas" init
.PHONY: init

plan: ;@ ## Perform dry run
	terraform -chdir="func" plan
	terraform -chdir="saas" plan
.PHONY: plan

apply: ;@ ## Build infrastructure
	terraform -chdir="func" apply
	terraform -chdir="saas" apply
.PHONY: apply

destroy: ;@ ## Destroy infrastructure
	terraform -chdir="func" destroy
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