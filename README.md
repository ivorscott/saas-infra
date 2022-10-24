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

2. Navigate to the desired environment: `local/saas`, `dev/saas`, `dev/eks`, etc.
3. Create you own `terraform.tfvars` file from the sample. For example:

```bash
profile  = ""
region  = "eu-central-1"
stage   = "local"
hostname = "devpie.local"
email   = ""
```

4. Provision infrastructure for your desired environment.

```bash
cd local # or dev
make init
make plan
make apply
```

See [dev](dev/README.md) setup.
