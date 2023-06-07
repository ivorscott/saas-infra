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
