# default arguments
HOSTNAME ?= devpie.io

init:
	terraform -chdir="saas" init
	terraform -chdir="eks" init
.PHONY: init

plan:
	terraform -chdir="saas" plan || true
	terraform -chdir="eks" plan -refresh=false
.PHONY: plan

apply:
	@ echo "Provisioning infrastructure..."

	terraform -chdir="saas" apply || true
	terraform -chdir="eks" apply -var eks_cluster_domain="$(HOSTNAME)" -var acm_certificate_domain="*.$(HOSTNAME)"

	@ CLUSTER_NAME=$(shell terraform -chdir="eks" output -raw eks_cluster_name); \
	aws eks --region $$AWS_DEFAULT_REGION update-kubeconfig --name $$CLUSTER_NAME

	@ cd ..; ./scripts/generate-secrets.sh
	@ cd ..; ./scripts/install-ebs-csi-driver.sh
	@ cd ..; ./scripts/argocd-login.sh

	argocd app create dev-apps \
	--dest-namespace default  \
	--dest-server https://kubernetes.default.svc  \
	--repo https://github.com/devpies/saas-infra.git \
	--path "manifests"

	argocd app sync dev-apps
.PHONY: dev

delete:
	argocd app delete dev-apps --cascade
.PHONY: delete

destroy:
	terraform -chdir="./dev/saas" destroy -auto-approve
	terraform -chdir="./dev/eks" destroy \
	-var eks_cluster_domain="" \
	-var acm_certificate_domain="" -auto-approve
.PHONY: destroy