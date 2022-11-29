
.DEFAULT_GOAL := help

init: ;@ ## Initialize workspace
	terraform -chdir="eks" init
	terraform -chdir="saas" init
.PHONY: init

plan-eks: ;@ ## Perform eks dry run
	terraform -chdir="eks" plan -refresh=false
	@ # -refresh=false fixes issue https://github.com/aws-ia/terraform-aws-eks-blueprints/issues/762
.PHONY: plan-eks

plan-saas: ;@ ## Perform saas dry run
	terraform -chdir="saas" plan
.PHONY: plan-saas

apply-eks: ;@ ## Build eks infrastructure
	@ echo "Provisioning infrastructure..."
	terraform -chdir="eks" apply
.PHONY: apply-eks

apply-saas: ;@ ## Build saas infrastructure
	@ echo "Provisioning infrastructure..."
	terraform -chdir="saas" apply
.PHONY: apply-saas

setup: ;@ ## Execute post infrastructure setup scripts
	@ CLUSTER_NAME=$(shell terraform -chdir="eks" output -raw eks_cluster_name); \
	aws eks --region $$AWS_DEFAULT_REGION update-kubeconfig --name $$CLUSTER_NAME

	@cd ..; ./scripts/generate-secrets.sh dev
	@cd ..; ./scripts/install-ebs-csi-driver.sh
	@cd ..; ./scripts/argocd-login.sh
	@cd ..; ./scripts/create-argocd-app.sh
.PHONY: setup

destroy-apps: ;@ ## Destroy argocd application
	@cd ..; ./scripts/argocd-login.sh
	argocd app delete dev-apps --cascade
.PHONY: destroy-apps

destroy-saas: ;@ ## Destroy saas infrastructure
	terraform -chdir="saas" destroy
.PHONY: destroy-saas

destroy-eks: ;@ ## Destroy eks infrastructure
	terraform -chdir="eks" destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
	terraform -chdir="eks" destroy -target="module.eks_blueprints" -auto-approve
	terraform -chdir="eks" destroy -auto-approve
.PHONY: destroy-eks

help:
	@echo
	@echo "- Setup Instructions -"
	@echo
	@echo 1. make init
	@echo 2. make plan-eks
	@echo 3. make apply-eks
	@echo 4. make plan-saas
	@echo 5. make apply-saas
	@echo 6. make setup
	@echo
	@grep -hE '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: help