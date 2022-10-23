#!/bin/bash
# This script automates ArgoCD API Server login.

read -sp 'Enter the ArgoCD admin password: ' password
echo '***************'
argocd login localhost:8080 --insecure --username admin --password $password