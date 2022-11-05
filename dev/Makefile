
.DEFAULT_GOAL := help

init: ;@ ## Initialize workspace
	terraform -chdir="saas" init
	terraform -chdir="eks" init
.PHONY: init

plan: ;@ ## Perform dry run
	terraform -chdir="saas" plan || true
	terraform -chdir="eks" plan -refresh=false # -refresh=false fixes issue
	# https://github.com/aws-ia/terraform-aws-eks-blueprints/issues/762
.PHONY: plan

apply: ;@ ## Build infrastructure
	@ echo "Provisioning infrastructure..."

	terraform -chdir="saas" apply || true
	terraform -chdir="eks" apply

	@ CLUSTER_NAME=$(shell terraform -chdir="eks" output -raw eks_cluster_name); \
	aws eks --region $$AWS_DEFAULT_REGION update-kubeconfig --name $$CLUSTER_NAME

	@ cd ..; ./scripts/generate-secrets.sh
	@ cd ..; ./scripts/install-ebs-csi-driver.sh
	@ cd ..; ./scripts/argocd-login.sh
	@ cd ..; ./scripts/create-argocd-app.sh
.PHONY: dev

delete: ;@ ## Delete argocd application
	argocd app delete dev-apps --cascade
.PHONY: delete

destroy: ;@ ## Destroy infrastructure
	terraform -chdir="saas" destroy
	terraform -chdir="eks" destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
	terraform -chdir="eks" destroy -target="module.eks_blueprints" -auto-approve
	terraform -chdir="eks" destroy -auto-approve
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