include .env

# default arguments
hostname ?= devpie.io

init:
	terraform init
.PHONY: init

build:
	terraform apply \
	-var eks_cluster_domain      = "$(hostname)" \
    -var acm_certificate_domain  = "*.$(hostname)"
.PHONY: build

up:
	kubectl apply -f ./manifests
.PHONY: up

down:
	kubectl delete -f ./manifests
.PHONY: down

apply: init build up
.PHONY: apply

destroy: down
	terraform destroy \
	-var eks_cluster_domain="" \
	-var acm_certificate_domain="" \
	-auto-approve
.PHONY: destroy