# Infra

contents:

- vpc
- kubernetes config
- kubernetes manifests
- aws load balancer controller
- external-dns
- iam roles for service accounts
- acm tls termination

## getting started

### requirements

- aws account
- aws route53 hosted zone
- existing domain name in hosted zone

```bash
# create
make apply hostname=example.com hosted_zone_id=xxxxxxxxxxxxxx

# destroy
make destroy
```

optionally, you can create the following environment variables in an .env file in the root folder

```bash
ENV_HOSTNAME=example.com
ENV_ZONE_ID=xxxxxxxxxxxxxx
```

### references

- [terraform-provider-kubernetes](https://github.com/hashicorp/terraform-provider-kubernetes/tree/main/_examples/eks) inspiration

- [aws load balancer controller, acm, external-dns, and traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/) inspiration

- [argo cd](https://argoproj.github.io/argo-cd/getting_started/) deployment detects changes in this repository

