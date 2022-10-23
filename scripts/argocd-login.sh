#!/bin/bash
# This script automates ArgoCD API Server login.

lsof -t -i:8080 | xargs -r kill
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443 > /dev/null 2>&1 &

read -sp 'Enter the ArgoCD admin password: ' password
echo '***************'
argocd login localhost:8080 --insecure --username admin --password $password