terraform {
  required_version = ">= 0.15.5, <= 1.2.3"

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

module "baseline" {
  source = "../../modules/baseline"
  stage               = var.stage
}

module "tenant" {
  source = "../../modules/tenant"
  stage         = var.stage
  hostname      = var.hostname
}

module "rds" {
  source = "../../modules/rds"
  stage         = var.stage
  hostname      = var.hostname
}