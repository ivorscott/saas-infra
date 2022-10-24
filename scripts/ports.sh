#!/bin/bash
# This script port forwards cluster applications.

# ArgoCD
lsof -t -i:8080 | xargs -r kill
kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443 > /dev/null 2>&1 &

# NATS
lsof -t -i:4222 | xargs -r kill
kubectl port-forward service/nats-svc 4222:4222 > /dev/null 2>&1 &