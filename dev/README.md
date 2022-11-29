# Dev Infra

## Getting Started

The dev environment is expensive and not necessary for local development.
It deploys an AWS EKS cluster, 3 RDS Postgres instances and more.

#### Dev Requirements
- aws account
- s3 bucket for terraform state named: `devpie.io-terraform`
- github personal access token with `read:packages` scope
- install [terraform](https://www.terraform.io/) <= 1.3.5
- route53 hosted zone 
- existing domain in hosted zone
- install [argocd cli](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli)
- install [kubectl](https://kubernetes.io/docs/tasks/tools/)
- install [pgcli](https://www.pgcli.com/install)
- install [jq](https://stedolan.github.io/jq/)

__Cheatsheats__

- [Debugging Tips](./docs/debugging.md)

### Setup
1. Configure your `~/.bash_profile` or `~/.zprofile` with AWS credentials.
    ```bash
    export AWS_ACCESS_KEY_ID=<YourAccessKeyID>
    export AWS_SECRET_ACCESS_KEY=<YourSecretAccessKey>
    export AWS_DEFAULT_REGION=<YourDefaultRegion>
    ```
    Apply the changes by executing `source ~/.bash_profile` or `source ~/.zprofile` in your terminal.


2. Create a named profile. 

    ```bash
    aws configure --profile <name>
    ```
   Terraform scripts should use the profile for AWS authentication instead of hard coded credentials.


3. Create `terraform.tfvars` files for `dev/saas` & `dev/eks` modules (use sample files).
    ```bash
    cp dev/saas/terraform.tfvars.sample dev/saas/terraform.tfvars
    cp dev/eks/terraform.tfvars.sample dev/eks/terraform.tfvars
    ```
    Update the contents with sensible values. Don't forget to use your AWS profile.


4. Add `.ghcr.token` to the project root. Copy your Github Personal Access Token and add it here. This token allows the cluster to 
pull container images. It should have `read:packages` scope.


5. Add `.traefik.password` to the project root. Insert a base64 encoded password to the file. Avoid accidentally including newline characters.
This is used to access the basic auth protected Traefik dashboard.
    ```bash
    echo -n "MyP@ssword" | base64 # -n removes the trailing newline character from the result
    ```
    `.ghcr.token` and `.traefik.password` should not be committed to git.


6. Provision the infrastructure.

```bash
$ make

- Setup Instructions -

1. make init
2. make plan-eks
3. make apply-eks
4. make plan-saas
5. make apply-saas
6. make setup

init                 Initialize workspace
plan-eks             Perform eks dry run
plan-saas            Perform saas dry run
apply-eks            Build eks infrastructure
apply-saas           Build saas infrastructure
setup                Execute post infrastructure setup scripts
delete               Delete argocd application
destroy              Destroy infrastructure
```

7. Find and copy the initial password for the ArgoCD UI.
```bash
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

8. Navigate to the ArgoCD UI: `http://localhost:8080` or `https://argocd-dev.devpie.io`. Login with the copied initial password; the username is `admin`. Once logged in, 
update your password to something else.

9. Navigate to https://traefik-dev.devpie.io/dashboard/#/ to see the Traefik dashboard.
The username is `saas-admin` and password is the decoded value of `.traefik.password`.

   > __TIP__ You can reveal the traefik credentials from the generated secret. 
   > ```bash 
   > kubectl get secret traefik-secret -o json | jq '.data | map_values(@base64d)'
   > {
   >   "username": "************"
   >   "password": "************"
   > }
   > ``` 
   > However, this requires you to have [jq](https://stedolan.github.io/jq/) installed. 


11. The SaaS administrator webapp is located at https://admin-dev.devpie.io. You should have received an email with a one time only password. 
After logging in, you will be asked to change your password.

### References

- [blog post: bootstrapping clusters with eks blueprints](https://aws.amazon.com/blogs/containers/bootstrapping-clusters-with-eks-blueprints/)
- [blog post: aws load balancer controller, acm, external-dns, and traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/) 
- [argo cd](https://argoproj.github.io/argo-cd/getting_started/)
- [eks blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints)
- [aws alb ssl-redirect](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/tasks/ssl_redirect/)
- [external dns w/ alb ingress](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/alb-ingress.md)