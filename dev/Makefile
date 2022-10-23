# default arguments
hostname ?= devpie.io

init:
	terraform -chdir="saas" init
	terraform -chdir="eks" init
.PHONY: init

plan:
	terraform -chdir="saas" plan || true
	terraform -chdir="eks" plan
.PHONY: plan

apply:
	@echo "Provisioning infrastructure..."
	 terraform -chdir="saas" apply || true
	 terraform -chdir="eks" apply -var eks_cluster_domain="$(hostname)" -var acm_certificate_domain="*.$(hostname)"

	 aws eks --region eu-central-1 update-kubeconfig --name dev

	@../scripts/generate-secrets.sh
	@../scripts/install-ebs-csi-driver.sh

	@kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
	@../scripts/argocd-login.sh

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