# Dev Infra

## Getting Started

The dev environment is expensive and not necessary for local development.
It deploys an AWS EKS cluster, 3 RDS Postgres instances and more.

#### Dev Requirements
- route53 hosted zone 
- existing domain in hosted zone
- install [argocd cli](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli)
- install [kubectl](https://kubernetes.io/docs/tasks/tools/)
- install [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/) 
- github personal access token to pull images

### Setup
1. Configure your `~/.bash_profile` with AWS credentials and create a named profile:

```bash
# .bash_profile 
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=
```

```bash
source ~/.bash_profile
aws configure --profile <name>
```

2. Create your own `terraform.tfvars` file in `dev/saas` & `dev/eks` (use the sample file).
3. Add `.ghcr.token` to the project root containing your Github Personal Access Token. This token allows the cluster to 
pull container images. It should have `read:packages` scope.
4. Add `.traefik.password` to the project root containing a base64 encoded password. This is used to access the traefik dashboard.
```bash
echo -n "MyP@ssword" | base64 # -n removes newline characters from the result
```

4. Provision infrastructure for the dev environment:

```bash
cd dev
make init
make plan
make apply
```
5. Port forward to connect to the ArgoCD API server.
```bash
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
```

6. Copy the initial password for the ArgoCD UI.
```bash
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

7. Navigate to http://localhost:8080 to see the ArgoCD UI. Use `admin` as your username and insert the copied password. Once logged in 
update your password to something else. 

8. Port forward to connect to the Traefik dashboard.
```bash
kubectl port-forward deploy/traefik -n traefik 9000:9000
```
9. Navigate to http://localhost:9000/dashboard/#/ to see the Traefik dashboard.

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

### References

- [blog post: bootstrapping clusters with eks blueprints](https://aws.amazon.com/blogs/containers/bootstrapping-clusters-with-eks-blueprints/)
- [blog post: aws load balancer controller, acm, external-dns, and traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/) 
- [argo cd](https://argoproj.github.io/argo-cd/getting_started/)
- [eks blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints)
- [aws alb ssl-redirect](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/tasks/ssl_redirect/)
- [external dns w/ alb ingress](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/alb-ingress.md)