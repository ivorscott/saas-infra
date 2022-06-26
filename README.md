# Infra

> __USE AT YOUR OWN RISK.__ 
> 
>  The `local` stage is the cheapest, it only provisions AWS Cognito. 
> - Configure a billing alarm on your AWS account to protect yourself against large unexpected bills.
> - Always destroy unused environments with `terraform destroy` to reduce costs.
> 
>The `dev` stage will provision an 
>1) EKS cluster
>2) Three DynamoDB tables
>3) Three RDS Postgres
>instances
>4) A Code Pipeline, and more.
>
> Be careful. Read through the code. Charges may apply even on the AWS Free Tier. 
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
hostname = "devpie.local"
email   = ""
```

3. Provision infrastructure for your environment.

```bash
terraform apply
```

### References

- [blog post: bootstrapping clusters with eks blueprints](https://aws.amazon.com/blogs/containers/bootstrapping-clusters-with-eks-blueprints/)
- [blog post: aws load balancer controller, acm, external-dns, and traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/) 
- [argo cd](https://argoproj.github.io/argo-cd/getting_started/)
