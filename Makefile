include .env

# default arguments
hostname ?= ${ENV_HOSTNAME}
zone ?= ${ENV_ZONE_ID}

kconfig = KUBECONFIG=./kubeconfig

init:
	terraform init
.PHONY: init

build:
	terraform apply \
	-var hostname="$(hostname)" \
	-var hosted_zone_id="$(zone)" -auto-approve
	./manifests/setup_ingress.sh $(shell terraform output -raw acm_cert_arn) $(hostname)
.PHONY: build

up:
	$(kconfig) kubectl apply -f ./manifests/deployment.yml -f ./manifests/traefik.yml -f ./manifests/ingress.yml
	$(kconfig) kubectl apply -f ./manifests/ingress-route.yml
.PHONY: up

down:
	$(kconfig) kubectl delete -f ./manifests/ingress-route.yml
	$(kconfig) kubectl delete -f ./manifests/deployment.yml -f ./manifests/traefik.yml -f ./manifests/ingress.yml
.PHONY: down

apply: init build up
.PHONY: apply

destroy: down
	terraform destroy -var hostname="" -var hosted_zone_id="" -auto-approve
.PHONY: destroy
