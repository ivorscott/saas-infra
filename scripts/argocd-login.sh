#!/bin/bash
# This script automates ArgoCD login.

password=`kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

argocd login \
--username "admin" \
--password $password \
--insecure \
--port-forward \
--plaintext