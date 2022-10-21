terraform {
  required_version = ">= 0.15.5, <= 1.3.3"
}

data "aws_caller_identity" "current" {}

# Setup Cognito Admin UserPool + Invitation Email
resource "aws_cognito_user_pool" "pool" {
  name = "${var.stage}-AdminUserPool"

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_subject = "Your DevPie Admin temporary password"
      email_message = <<EOF
      <b>Welcome to DevPie Admin</b> <br>
      <br>
      You can log into the app <a href="https://admin-${var.stage}.${var.hostname}">here</a>.
      <br>
      Your username is: <b>{username}</b>
      <br>
      Your temporary password is: <b>{####}</b>
      <br>
EOF
      sms_message = "Username: {username}. Password: {####}"
    }
  }
}

# Setup Cognito UserPoolDomain
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.stage}-admin-pool-${data.aws_caller_identity.current.account_id}"
  #certificate_arn = aws_acm_certificate.cert.arn
  user_pool_id = aws_cognito_user_pool.pool.id
}

# Setup Cognito UserPoolClient
resource "aws_cognito_user_pool_client" "client" {
  name = "${var.stage}-AdminUserPoolClient"

  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret     = false
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["email", "openid", "phone", "profile"]
  callback_urls = ["http://localhost:4001/auth-challenge"]
  prevent_user_existence_errors = "ENABLED"
}

# Configure UserPool User
resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.pool.id
  desired_delivery_mediums = ["EMAIL"]
  force_alias_creation = false

  attributes = {
    email = var.admin_email_address
    email_verified = true
  }

  username = var.admin_email_address
}