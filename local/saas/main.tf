module "admin" {
  source              = "../../modules/admin"
  stage               = var.stage
  hostname            = var.hostname
  admin_email_address = var.email
}

module "tenant" {
  source        = "../../modules/tenant"
  stage         = var.stage
  hostname      = var.hostname
  region        = var.region
}

module "baseline" {
  source                     = "../../modules/baseline"
  stage                      = var.stage
  shared_user_pool_id        = module.tenant.shared_user_pool_id
  shared_user_pool_client_id = module.tenant.shared_user_pool_client_id
}

