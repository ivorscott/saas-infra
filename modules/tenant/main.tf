terraform {
  required_version = ">= 0.15.5, <= 1.4.6"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_lambda_dynamodb" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Scan"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/local-tenants",
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/local-connections"
    ]
  }
}

module "modifytoken" {
  source = "../../modules/func"
  stage = var.stage
  region = var.region
  package_name = "modifytoken"
  package_description = "Add tenant connections to token before generation."
  policy_name = "AllowLambdaDynamoDBPolicy"
  policy_description = "Policy for lambda dynamodb usage"
  policy_json =  data.aws_iam_policy_document.allow_lambda_dynamodb.json
}

module "updatestatus" {
  source = "../../modules/func"
  stage = var.stage
  region = var.region
  package_name = "updatestatus"
  package_description = "Update tenant status post sign up confirmation."
  policy_name = "AllowLambdaDynamoDBPolicy"
  policy_description = "Policy for lambda dynamodb usage"
  policy_json =  data.aws_iam_policy_document.allow_lambda_dynamodb.json
  operation="sed -i 's/TableName: aws.String(.*/TableName: aws.String(\"${var.stage}-tenants\"),/' ./main.go"
}

# Setup Cognito Application UserPool + Invitation Email
resource "aws_cognito_user_pool" "pool" {
  name = "${var.stage}-SharedTenantPool"

  lambda_config {
      pre_token_generation = module.modifytoken.lambda_function_arn
      post_confirmation = module.updatestatus.lambda_function_arn
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_subject = "Your temporary password for DevPie"
      email_message = <<EOF
      <b>Welcome to DevPie</b> <br>
      <br>
      You can log into the app <a href="https://${var.hostname}">here</a>.
      <br>
      Your username is: <b>{username}</b>
      <br>
      Your temporary password is: <b>{####}</b>
      <br>
EOF
      sms_message = "Username: {username}. Password: {####}"
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "tenant-id"
    mutable             = false
  }

  schema {
    attribute_data_type = "String"
    name                = "company-name"
    mutable             = false
  }

  schema {
    attribute_data_type = "Number"
    name                = "account-owner"
    mutable             = false
    number_attribute_constraints {
      min_value = "0"
      max_value = "1"
    }
  }

  schema {
    attribute_data_type = "Number"
    name                = "m2m-client"
    mutable             = false
    number_attribute_constraints {
      min_value = "0"
      max_value = "1"
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "full-name"
    mutable             = true
  }

  # NOTE: cannot modify or remove schema items
  lifecycle {
    ignore_changes = [
      schema
    ]
  }
}

# Setup Cognito UserPoolClient
resource "aws_cognito_user_pool_client" "client" {
  name = "${var.stage}-SharedTenantPoolClient"

  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret               = false
  explicit_auth_flows           = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows           = ["code", "implicit"]
  allowed_oauth_scopes          = ["email", "openid", "phone", "profile"]
  callback_urls                 = ["https://${var.hostname}/auth-challenge"]
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_lambda_permission" "allow_cognito_to_modifytoken" {
  statement_id  = "AllowModifyTokenExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = module.modifytoken.lambda_function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.pool.id}"
}

resource "aws_lambda_permission" "allow_cognito_to_updatestatus" {
  statement_id  = "AllowUpdateStatusExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = module.updatestatus.lambda_function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.pool.id}"
}
