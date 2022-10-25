init: # initialize workspace
	terraform -chdir="saas" init
	terraform -chdir="eks" init
.PHONY: init

plan: # perform dry run
	terraform -chdir="saas" plan || true
	terraform -chdir="eks" plan -refresh=false # -refresh=false is a workaround for bug https://github.com/aws-ia/terraform-aws-eks-blueprints/issues/762
.PHONY: plan

apply: # build infrastructure
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

delete: # delete argocd application
	argocd app delete dev-apps --cascade
.PHONY: delete

destroy: # destroy infrastructure
	terraform -chdir="saas" destroy
	terraform -chdir="eks" destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
	terraform -chdir="eks" destroy -target="module.eks_blueprints" -auto-approve
	terraform -chdir="eks" destroy -auto-approve
.PHONY: destroy