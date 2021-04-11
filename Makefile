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
.PHONY: build

up:
	$(kconfig) kubectl apply -f ./manifests/secrets.yaml
	./setup_ingress.sh $(shell terraform output -raw acm_cert_arn) qa.$(hostname)
	$(kconfig) kubectl apply -f ./manifests/deployment.yaml -f ./manifests/traefik.yaml -f ./manifests/ingress.yaml
	$(kconfig) kubectl apply -f ./manifests/ingress-route.yaml
.PHONY: up

down:
	$(kconfig) kubectl delete -f ./manifests/ingress-route.yaml
	$(kconfig) kubectl delete -f ./manifests/deployment.yaml -f ./manifests/traefik.yaml -f ./manifests/ingress.yaml
	$(kconfig) kubectl apply -f ./manifests/secrets.yaml
.PHONY: down

apply: init build up
.PHONY: apply

destroy: down
	terraform destroy -var hostname="" -var hosted_zone_id="" -auto-approve
.PHONY: destroy
