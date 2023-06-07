terraform {
  required_version = ">= 0.15.5, <= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
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