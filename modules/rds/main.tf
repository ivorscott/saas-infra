terraform {
  required_version = ">= 0.15.5, <= 1.4.6"
}

locals {
  name = "postgres"
  region = var.region
  tags = {
    Environment = var.stage
  }
}

/**
 * RDS Security Group.
 *
 * The default security group for rds instances.
 */
resource "aws_security_group" "rds" {
  name        = "RDS_SG"
  description = "Default RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    security_groups = [aws_security_group.rds_access.id]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    security_groups = [aws_security_group.rds_access.id]
  }

  tags = {
    Environment = var.stage
  }
}

/**
 * POD Security Group.
 *
 * The default security group for pods requiring rds access.
 */
resource "aws_security_group" "rds_access" {
  name        = "POD_SG"
  description = "Allow RDS Access from Kubernetes Pods"
  vpc_id      = var.vpc_id

  # allow POD SG to connect to traefik
#  ingress {
#    from_port = 8000
#    to_port   = 8000
#    protocol  = "tcp"
#    self      = true
#  }
#
#  # allow POD SG to connect to traefik
#  ingress {
#    from_port = 443
#    to_port   = 443
#    protocol  = "tcp"
#    self      = true
#  }

  # allow POD SG to connect to NODE GROUP SG using TCP 53
  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "tcp"
    security_groups = [var.worker_node_security_group_id]
  }

  # allow POD SG to connect to NODE GROUP SG using UDP 53
  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    security_groups = [var.worker_node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.stage
  }
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
  username = "dbuser"
  port     = 5432

  db_subnet_group_name   = var.database_subnet_group
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible = true
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
  username = "dbuser"
  port     = 5432

  db_subnet_group_name   = var.database_subnet_group
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible = true
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
  username = "dbuser"
  port     = 5432

  db_subnet_group_name   = var.database_subnet_group
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible = true
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
}