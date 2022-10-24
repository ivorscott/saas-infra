	#!/bin/bash
  # This script automates ArgoCD app creation and deployment.

argocd app create dev-apps \
--dest-namespace default  \
--dest-server https://kubernetes.default.svc  \
--repo https://github.com/devpies/saas-infra.git \
--path "manifests"

argocd app sync dev-apps