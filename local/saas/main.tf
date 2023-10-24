terraform {
  required_version = ">= 0.15.5, <= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
    archive = {
      source = "hashicorp/archive"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

module "admin" {
  source = "../../modules/admin"
  stage               = var.stage
  hostname             = var.hostname
  admin_email_address = var.email
}

module "tenant" {
  source = "../../modules/tenant"
  stage         = var.stage
  hostname      = var.hostname
}

module "baseline" {
  source = "../../modules/baseline"
  stage               = var.stage
  shared_user_pool_id = module.tenant.shared_user_pool_id
  shared_user_pool_client_id = module.tenant.shared_user_pool_client_id
}

# Build the binary for the lambda function (Uses Sparse checkout)
# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
resource "null_resource" "function_binary" {
  provisioner "local-exec" {
    command = <<-EOT
      mkdir temp
      cd temp
      git init
      git remote add -f origin https://github.com/devpies/saas-core

      git config core.sparseCheckout true

      echo "pkg/lambda/" >> .git/info/sparse-checkout

      git pull origin main

      cd pkg/lambda/modifytoken
      GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' -o ${path.module}/lambdas/modifytoken .
    EOT
  }
}

