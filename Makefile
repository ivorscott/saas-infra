# default arguments
hostname ?= devpie.io

local:
	terraform -chdir="./local/saas" init
	terraform -chdir="./local/saas" apply
.PHONY: local

dev:
	terraform -chdir="./dev/saas" init
	terraform -chdir="./dev/saas" apply

	terraform -chdir="./dev/eks" init
	terraform -chdir="./dev/eks" apply \
	-var eks_cluster_domain="$(hostname)" \
	-var acm_certificate_domain="*.$(hostname)"

	shell($(terraform -chdir="./dev/eks" output -raw configure_kubectl))

	./scripts/generate-secrets.sh
	./scripts/install-ebs-csi-driver.sh

	argocd app create dev-apps \
	--dest-namespace argocd  \
	--dest-server https://kubernetes.default.svc  \
	--repo https://github.com/devpies/saas-infra.git \
	--path "manifests"

	argocd app sync dev-apps
.PHONY: dev

delete:
	argocd app delete dev-apps --cascade
.PHONY: delete

destroy: delete
	terraform -chdir="./dev/saas" destroy -auto-approve
	terraform -chdir="./dev/eks" destroy \
	-var eks_cluster_domain="" \
	-var acm_certificate_domain="" -auto-approve
.PHONY: destroy