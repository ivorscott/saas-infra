
.DEFAULT_GOAL := help

init: ;@ ## Initialize workspace
	terraform -chdir="eks" init
	terraform -chdir="saas" init
.PHONY: init

plan: ;@ ## Perform eks dry run
	terraform -chdir="eks" plan
	terraform -chdir="saas" plan
.PHONY: plan

apply: ;@ ## Build eks infrastructure
	@ echo "Provisioning infrastructure..."
	@terraform -chdir="eks" apply

	@v1=$(shell terraform -chdir="eks" output -raw vpc_id); \
	v2=$(shell terraform -chdir="eks" output -raw vpc_cidr_block); \
	v3=$(shell terraform -chdir="eks" output -raw database_subnet_group); \
	v4=$(shell terraform -chdir="eks" output -raw worker_node_security_group_id); \
	terraform -chdir="saas" apply \
	-var="vpc_id=$$v1" \
	-var="vpc_cidr_block=$$v2" \
	-var="database_subnet_group=$$v3" \
	-var="worker_node_security_group_id=$$v4"
.PHONY: apply

scripts: ;@ ## Execute post infrastructure setup scripts
	@ CLUSTER_NAME=$(shell terraform -chdir="eks" output -raw eks_cluster_name); \
	aws eks --region $$AWS_DEFAULT_REGION update-kubeconfig --name $$CLUSTER_NAME;

	@cd ..; ./scripts/security-groups-for-pods.sh dev
	@cd ..; ./scripts/generate-secrets.sh dev
	@cd ..; ./scripts/argocd-login.sh
	@cd ..; ./scripts/create-argocd-app.sh
.PHONY: scripts

delete: ;@ ## Delete argocd application
	@cd ..; ./scripts/argocd-login.sh
	argocd --port-forward app delete dev-apps --cascade
.PHONY: delete

destroy: ;@ ## Destroy infrastructure
	terraform -chdir="eks" destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
	terraform -chdir="eks" destroy -target="module.eks_blueprints" -auto-approve
	terraform -chdir="eks" destroy -auto-approve
	terraform -chdir="saas" destroy
.PHONY: destroy

help:
	@echo
	@echo "- Setup Instructions -"
	@echo
	@echo 1. make init
	@echo 2. make plan
	@echo 3. make apply
	@echo 4. make scripts
	@echo
	@grep -hE '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: help