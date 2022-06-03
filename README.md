# SaaS-Infra

This project is a part of "AWS SaaS app in 30 days" - _Proof of Concept_

## Provision Resources

#### 1. Choose a SaaS Enviroment
For example:
```
cd local/saas
```

#### 2. Copy `terraform.tfvars.sample` and Create `terraform.tfvars`.
```bash
profile  = "REPLACE-WITH-YOUR-AWS-PROFILE" # from `aws configure`
region  = "eu-central-1"
stage   = "local"
elb_url = "localhost:4000"
email   = "REPLACE-WITH-YOUR-EMAIL"
```
#### 3. Execute
```bash
terraform apply
```