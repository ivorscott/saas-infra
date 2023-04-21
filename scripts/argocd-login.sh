#!/bin/bash

read -sp 'Enter the ArgoCD admin password: ' password
echo '***************'

argocd login \
--username "admin" \
--password $password \
--insecure \
--port-forward \
--plaintext