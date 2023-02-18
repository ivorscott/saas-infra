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
  stage                     = var.stage
  hostname                  = var.hostname
  instance_type             = var.rds_instance_type
  vpc_id                    = var.vpc_id
  vpc_cidr_block            = var.vpc_cidr_block
  database_subnet_group     = var.database_subnet_group
  cluster_security_group_id = var.cluster_security_group_id
}