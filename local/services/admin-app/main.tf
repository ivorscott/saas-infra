terraform {
  required_version = ">= 0.15.5, <= 1.1.9"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

module "admin" {
  source = "../../../modules/admin"

  stage = var.stage
  admin_email_address = var.email
  elb_url = var.elb_url
}