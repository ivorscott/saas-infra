output "db_users_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_users.db_instance_address
}

output "db_users_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_users.db_instance_arn
}

output "db_users_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_users.db_instance_availability_zone
}

output "db_users_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_users.db_instance_endpoint
}

output "db_users_instance_engine" {
  description = "The database engine"
  value       = module.db_users.db_instance_engine
}

output "db_users_instance_engine_version" {
  description = "The running version of the database"
  value       = module.db_users.db_instance_engine_version_actual
}

output "db_users_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_users.db_instance_hosted_zone_id
}

output "db_users_instance_id" {
  description = "The RDS instance ID"
  value       = module.db_users.db_instance_id
}

output "db_users_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_users.db_instance_resource_id
}

output "db_users_instance_status" {
  description = "The RDS instance status"
  value       = module.db_users.db_instance_status
}

output "db_users_instance_name" {
  description = "The database name"
  value       = module.db_users.db_instance_name
}

output "db_users_instance_username" {
  description = "The master username for the database"
  value       = module.db_users.db_instance_username
  sensitive   = true
}

output "db_users_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db_users.db_instance_password
  sensitive   = true
}

output "db_users_instance_port" {
  description = "The database port"
  value       = module.db_users.db_instance_port
}

output "db_users_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db_users.db_subnet_group_id
}

output "db_users_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db_users.db_subnet_group_arn
}

output "db_users_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db_users.db_parameter_group_id
}

output "db_users_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_users.db_parameter_group_arn
}

output "db_users_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db_users.db_instance_cloudwatch_log_groups
}

# Projects database

output "db_projects_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_projects.db_instance_address
}

output "db_projects_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_projects.db_instance_arn
}

output "db_projects_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_projects.db_instance_availability_zone
}

output "db_projects_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_projects.db_instance_endpoint
}

output "db_projects_instance_engine" {
  description = "The database engine"
  value       = module.db_projects.db_instance_engine
}

output "db_projects_instance_engine_version" {
  description = "The running version of the database"
  value       = module.db_projects.db_instance_engine_version_actual
}

output "db_projects_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_projects.db_instance_hosted_zone_id
}

output "db_projects_instance_id" {
  description = "The RDS instance ID"
  value       = module.db_projects.db_instance_id
}

output "db_projects_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_projects.db_instance_resource_id
}

output "db_projects_instance_status" {
  description = "The RDS instance status"
  value       = module.db_projects.db_instance_status
}

output "db_projects_instance_name" {
  description = "The database name"
  value       = module.db_projects.db_instance_name
}

output "db_projects_instance_username" {
  description = "The master username for the database"
  value       = module.db_projects.db_instance_username
  sensitive   = true
}

output "db_projects_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db_projects.db_instance_password
  sensitive   = true
}

output "db_projects_instance_port" {
  description = "The database port"
  value       = module.db_projects.db_instance_port
}

output "db_projects_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db_projects.db_subnet_group_id
}

output "db_projects_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db_projects.db_subnet_group_arn
}

output "db_projects_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db_projects.db_parameter_group_id
}

output "db_projects_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_projects.db_parameter_group_arn
}

output "db_projects_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db_projects.db_instance_cloudwatch_log_groups
}

# Admin database

output "db_admin_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_admin.db_instance_address
}

output "db_admin_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_admin.db_instance_arn
}

output "db_admin_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_admin.db_instance_availability_zone
}

output "db_admin_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_admin.db_instance_endpoint
}

output "db_admin_instance_engine" {
  description = "The database engine"
  value       = module.db_admin.db_instance_engine
}

output "db_admin_instance_engine_version" {
  description = "The running version of the database"
  value       = module.db_admin.db_instance_engine_version_actual
}

output "db_admin_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_admin.db_instance_hosted_zone_id
}

output "db_admin_instance_id" {
  description = "The RDS instance ID"
  value       = module.db_admin.db_instance_id
}

output "db_admin_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_admin.db_instance_resource_id
}

output "db_admin_instance_status" {
  description = "The RDS instance status"
  value       = module.db_admin.db_instance_status
}

output "db_admin_instance_name" {
  description = "The database name"
  value       = module.db_admin.db_instance_name
}

output "db_admin_instance_username" {
  description = "The master username for the database"
  value       = module.db_admin.db_instance_username
  sensitive   = true
}

output "db_admin_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db_admin.db_instance_password
  sensitive   = true
}

output "db_admin_instance_port" {
  description = "The database port"
  value       = module.db_admin.db_instance_port
}

output "db_admin_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db_admin.db_subnet_group_id
}

output "db_admin_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db_admin.db_subnet_group_arn
}

output "db_admin_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db_admin.db_parameter_group_id
}

output "db_admin_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_admin.db_parameter_group_arn
}

output "db_admin_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db_admin.db_instance_cloudwatch_log_groups
}