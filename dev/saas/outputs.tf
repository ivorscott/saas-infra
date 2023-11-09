output "admin_user_pool_id" {
  value = module.admin.user_pool_id
}

output "admin_user_pool_client_id" {
  value = module.admin.user_pool_client_id
}

output "shared_user_pool_id" {
  value = module.tenant.shared_user_pool_id
}

output "shared_user_pool_client_id" {
  value = module.tenant.shared_user_pool_client_id
}

output "postgres_instance_id_users" {
  value = module.rds.db_users_instance_id
}

output "postgres_hostname_users" {
  value = module.rds.db_users_instance_address
}

output "postgres_username_users" {
  value = module.rds.db_users_instance_username
  sensitive = true
}

output "postgres_password_users" {
  value = module.rds.db_users_instance_password
  sensitive = true
}

output "postgres_instance_id_projects" {
  value = module.rds.db_projects_instance_id
}

output "postgres_hostname_projects" {
  value = module.rds.db_projects_instance_address
}

output "postgres_username_projects" {
  value = module.rds.db_projects_instance_username
  sensitive = true
}

output "postgres_password_projects" {
  value = module.rds.db_projects_instance_password
  sensitive = true
}

output "postgres_instance_id_subscriptions" {
  value = module.rds.db_subscriptions_instance_id
}

output "postgres_hostname_subscriptions" {
  value = module.rds.db_subscriptions_instance_address
}

output "postgres_username_subscriptions" {
  value = module.rds.db_subscriptions_instance_username
  sensitive = true
}

output "postgres_password_subscriptions" {
  value = module.rds.db_subscriptions_instance_password
  sensitive = true
}

output "postgres_instance_id_admin" {
  value = module.rds.db_admin_instance_id
}

output "postgres_hostname_admin" {
  value = module.rds.db_admin_instance_address
}

output "postgres_username_admin" {
  value = module.rds.db_admin_instance_username
  sensitive = true
}

output "postgres_password_admin" {
  value = module.rds.db_admin_instance_password
  sensitive = true
}

output "sg_rds_access" {
  value = module.rds.sg_rds_access
}