init: # initialize workspace
	terraform -chdir="saas" init
.PHONY: init

apply: # build infrastructure
	terraform -chdir="saas" apply
.PHONY: apply

plan: # perform dry run
	terraform -chdir="saas" plan
.PHONY: plan
