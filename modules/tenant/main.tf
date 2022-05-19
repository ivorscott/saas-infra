terraform {
  required_version = ">= 0.15.5, <= 1.1.9"
}

# Setup Cognito Application UserPool + Invitation Email
resource "aws_cognito_user_pool" "tenant_pool" {
  name = "SharedTenantPool-${var.stage}"

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_subject = "Your temporary password for DevPie"
      email_message = <<EOF
      <b>Welcome to DevPie</b> <br>
      <br>
      You can log into the app <a href="http://${var.elb_url}/app/index.html">here</a>.
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
    attribute_data_type = "String"
    name                = "email"
    mutable             = true
  }
}

# Setup Cognito UserPoolClient
resource "aws_cognito_user_pool_client" "client" {
  name = "SharedTenantPoolClient-${var.stage}"

  user_pool_id = aws_cognito_user_pool.tenant_pool.id

  generate_secret     = false
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["email", "openid", "phone", "profile"]
  callback_urls = ["http://localhost/app", "https://${var.elb_url}/app"]
  prevent_user_existence_errors = "ENABLED"
}
