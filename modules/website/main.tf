terraform {
	required_version = ">= 0.15.5, <= 1.3.3"

	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "4.36.0"
		}
	}
}

provider "aws" {
	region = var.region
}

# To use an ACM certificate with CloudFront request the certificate in us-east-1
provider "aws" {
	alias  = "acm_provider"
	region = "us-east-1"
}