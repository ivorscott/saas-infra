output "admin_user_pool_id" {
  value = module.admin.user_pool_id
}

output "admin_app_client_id" {
  value = module.admin.app_client_id
}

output "tenant_user_pool_id" {
  value = module.tenant.user_pool_id
}

output "tenant_app_client_id" {
  value = module.tenant.app_client_id
}
