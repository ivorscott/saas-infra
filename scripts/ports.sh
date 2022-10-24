#!/bin/bash
# This script port forwards cluster applications.

# NATS
lsof -t -i:4222 | xargs -r kill
kubectl port-forward service/nats-svc 4222:4222 > /dev/null 2>&1 &