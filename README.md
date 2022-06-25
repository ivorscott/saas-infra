# Infra

> __USE AT YOUR OWN RISK.__ 
> 
>  The `local` stage is the cheapest, it only provisions AWS Cognito. 
> - Configure a billing alarm on your AWS account to protect yourself against large unexpected bills.
> - Always destroy unused environments with `terraform destroy` to reduce costs.
> 
>The `dev` stage provisions an 1) EKS cluster, 2) Three DynamoDB tables, 3) Three RDS Postgres
> instances, a Code Pipeline, etc. Read through the code. Charges apply even on the AWS Free Tier. 
> 

## Getting Started

### Requirements

- aws account
- install [terraform](https://www.terraform.io/)
- route53 hosted zone (not required for `local`)
- existing domain in hosted zone (not required for `local`)

### Setup
1. Navigate to desired SaaS environment `local/saas`, `dev/saas` etc.
2. Create you own `terraform.tfvars` file from the sample.
```
profile  = ""
region  = "eu-central-1"
stage   = "local"
hostname = "localhost:4000"
email   = ""
```

3. Provision infrastructure for your environment.

```bash
terraform apply
```


### references

- [terraform-provider-kubernetes](https://github.com/hashicorp/terraform-provider-kubernetes/tree/main/_examples/eks) inspiration

- [aws load balancer controller, acm, external-dns, and traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/) inspiration

- [argo cd](https://argoproj.github.io/argo-cd/getting_started/) deployment detects changes in this repository

- [client-core github workflows](https://github.com/ivorscott/client-core/tree/main/.github/workflows) clone this repository and updates manifests with new image tag
