terraform {
  required_version = ">= 0.15.5, <= 1.4.6"
}

# Create tenants Table
resource "aws_dynamodb_table" "tenants" {
  name = "${var.stage}-tenants"
  hash_key = "tenantId"

  attribute {
    name = "tenantId"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}

# Create tenants Table
resource "aws_dynamodb_table" "tenants_connections" {
  name = "${var.stage}-connections"
  hash_key = "userId"
  range_key = "tenantId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "tenantId"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}

# Create auth-info table
resource "aws_dynamodb_table" "auth_info" {
  name = "${var.stage}-auth-info"
  hash_key = "tenantPath"

  attribute {
    name = "tenantPath"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}

resource "aws_dynamodb_table_item" "add_auth_info_item" {
  table_name = aws_dynamodb_table.auth_info.name
  hash_key   = aws_dynamodb_table.auth_info.hash_key

  item = templatefile("${path.module}/templates/auth_info_item.json",
    {
      userPoolId       = var.shared_user_pool_id
      userPoolClientId = var.shared_user_pool_client_id
    }
  )
}

# Create silo-config table
resource "aws_dynamodb_table" "silo_config" {
  name = "${var.stage}-silo-config"
  hash_key = "tenantName"

  attribute {
    name = "tenantName"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}