#!/bin/bash
# This script runs Traefik locally.

lsof -t -i:9000 | xargs -r kill
kubectl port-forward deploy/traefik -n traefik 9000:9000 > /dev/null 2>&1 &