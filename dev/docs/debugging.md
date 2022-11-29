
## Debugging Cheatsheet

__Get app details__

```bash
argocd app get dev-apps
```

__Sync (aka Deploy) app__
```bash
argocd app sync dev-apps
```

__Print images in namespace__
```bash
kubectl get deploy -o wide -n default | awk '{ print $1, $7 }' | column -t
```

__Print events sorted__

```bash
kubectl -n default get events --sort-by='{.lastTimestamp}'
```

__Refresh Terraform state with the opportunity to review (useful if terraform outputs change)__
```bash
terraform apply -refresh-only
```

__Get Base64 encoded secret and decode it (requires jq)__
```bash
kubectl get secret traefik-secret -o json | jq '.data | map_values(@base64d)'
```

__Create a pod to debug a node__
```bash
kubectl debug node/<node name> -it --image=ubuntu
```