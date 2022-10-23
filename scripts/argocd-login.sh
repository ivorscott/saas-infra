#!/bin/bash

read -sp 'Enter the ArgoCD admin password: ' password
echo -n xxxxxxxxxxx
echo
argocd login localhost:8080 --insecure --username admin --password $password