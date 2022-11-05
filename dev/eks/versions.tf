terraform {
  required_version = ">= 0.15.5, <= 1.3.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }

  backend "s3" {
    bucket = "devpie.io-terraform"
    key    = "dev/eks/terraform.tfstate"
    region = "eu-central-1"
  }
}
