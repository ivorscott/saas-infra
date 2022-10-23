# Infra

Multi-tenant SaaS app built on AWS

## Getting Started

Available environments include `local` and `dev`. The dev environment is expensive and not necessary for local development.
It deploys an AWS EKS cluster, 3 RDS Postgres instances and more.

#### Local Requirements
- aws account
- install [terraform](https://www.terraform.io/)
#### Dev Requirements
- route53 hosted zone 
- existing domain in hosted zone
- install [argocd cli](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli)
- install [kubectl](https://kubernetes.io/docs/tasks/tools/)
- install [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/) 

### Setup
1. Navigate to the desired environment: `local/saas`, `dev/saas`, `dev/eks`, etc.
2. Create you own `terraform.tfvars` file from the sample. For example:

```bash
profile  = ""
region  = "eu-central-1"
stage   = "local"
hostname = "devpie.local"
email   = ""
```

3. Provision infrastructure for your desired environment.

```bash
cd local # or dev
make init
make plan
make apply
```

See [dev](dev/README.md) setup.

### References

- [blog post: bootstrapping clusters with eks blueprints](https://aws.amazon.com/blogs/containers/bootstrapping-clusters-with-eks-blueprints/)
- [blog post: aws load balancer controller, acm, external-dns, and traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/) 
- [argo cd](https://argoproj.github.io/argo-cd/getting_started/)
- [eks blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints)
