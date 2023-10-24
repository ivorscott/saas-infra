data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_lambda_dynamodb" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:Scan"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/local-tenants",
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/local-connections"
    ]
  }
}

module "func" {
  source = "../../modules/func"
  stage = var.stage
  region = var.region
  package_name = "modifytoken"
  package_description = "Add tenant connections to token before generation."
  policy_name = "AllowLambdaDynamoDBPolicy"
  policy_description = "Policy for lambda dynamodb usage"
  policy_json =  data.aws_iam_policy_document.allow_lambda_dynamodb.json
}

module "admin" {
  source = "../../modules/admin"
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

module "rds" {
  source = "../../modules/rds"
  stage                     = var.stage
  hostname                  = var.hostname
  instance_type             = var.rds_instance_type
  vpc_id                    = var.vpc_id
  vpc_cidr_block            = var.vpc_cidr_block
  database_subnet_group     = var.database_subnet_group
}