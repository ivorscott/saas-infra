# Local Infra

Multi-tenant SaaS app built on AWS

## Getting Started

Available environments include `local` and `dev`. The dev environment is expensive and not necessary for local development.
It deploys an AWS EKS cluster, 3 RDS Postgres instances and more.

#### Local Requirements
- aws account
- install [terraform](https://www.terraform.io/)

### Setup
1. Configure your `~/.bash_profile` with AWS credentials.

    ```bash
    export AWS_ACCESS_KEY_ID=<YourAccessKeyID>
    export AWS_SECRET_ACCESS_KEY=<YourSecretAccessKey>
    export AWS_DEFAULT_REGION=<YourDefaultRegion>
    ```
    Apply the changes by executing `source ~/.bash_profile` in your terminal.


2. Create a named profile.

    ```bash
    aws configure --profile <name>
    ```
    Terraform scripts should use the profile for AWS authentication instead of hard coded credentials.

3. Create `terraform.tfvars` file for the local/saas modules (use sample file).

    ```bash
    cp local/saas/terraform.tfvars.sample local/saas/terraform.tfvars
    ```

    Update the contents with sensible values. Don't forget to use your AWS profile.
4. 
    ```bash
    profile  = ""
    region  = "eu-central-1"
    stage   = "local"
    hostname = "devpie.local"
    email   = ""
    ```

5. Provision infrastructure for your desired environment.

```bash
cd local
make init
make plan
make apply
```

See [dev](dev/README.md) setup.
