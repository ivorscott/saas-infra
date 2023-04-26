terraform {
  required_version = ">= 0.15.5, <= 1.4.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.18"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }

  backend "s3" {
    bucket = "devpie.io-terraform"
    key    = "dev/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}
