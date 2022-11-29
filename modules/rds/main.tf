terraform {
  required_version = ">= 0.15.5, <= 1.3.5"
}

locals {
  name = "postgres"
  region = var.region
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

/*
 * Receive existing vpc resource.
 *
 * We require the vpc id of the vpc containing the eks cluster. This is
 * required for vpc peering.
 */
data aws_vpc "eks" {
  id = "dev"
}

/**
 * Make AWS account id available.
 *
 * This is usually required by vpc peering.
 */
data aws_caller_identity "current" {}

/**
 * VPC.
 *
 * The dedicated VPC for rds instances.
 */
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.99.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
  database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  tags = local.tags
}

/**
 * Security Group.
 *
 * The default security group for rds instances.
 */
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

/**
 * VPC peering connection.
 *
 * Establishes a relationship resource between the "eks" and "rds" VPCs.
 */
resource "aws_vpc_peering_connection" "eks2rds" {
  # The AWS Account ID.
  peer_owner_id = data.aws_caller_identity.current.account_id

  # Thee VPC ID for EKS resources.
  vpc_id        =  data.aws_vpc.eks.id

  # The VPC ID for RDS resources.
  peer_vpc_id   = module.vpc.vpc_id
  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = true
}

/**
 * Route rule.
 *
 * Creates a new route rule on the "eks" VPC main route table. All requests
 * to the "rds" VPC's IP range will be directed to the VPC peering
 * connection.
 */
resource "aws_route" "eks2rds" {
  route_table_id = data.aws_vpc.eks.main_route_table_id
  destination_cidr_block = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks2rds.id
}

/**
 * Route rule.
 *
 * Creates a new route rule on the "rds" VPC main route table. All requests
 * to the "eks" VPC's IP range will be directed to the VPC peering
 * connection.
 */
resource "aws_route" "rds2eks" {
  route_table_id = module.vpc.vpc_main_route_table_id
  destination_cidr_block = data.aws_vpc.eks.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks2rds.id
}


/**
 * RDS database.
 *
 * This is the users database.
 */
module "db_users" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "users-default"

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = var.instance_type

  allocated_storage = 20

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "users"
  username = "devpie_admin"
  port     = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
}

/**
 * RDS database.
 *
 * This is the projects database.
 */
module "db_projects" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "projects-default"

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = var.instance_type

  allocated_storage = 20

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "projects"
  username = "devpie_admin"
  port     = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
}

/**
 * RDS database.
 *
 * This is the admin database.
 */
module "db_admin" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "admin-default"

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = var.instance_type

  allocated_storage = 20

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "saas_admin"
  username = "devpie_admin"
  port     = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
}