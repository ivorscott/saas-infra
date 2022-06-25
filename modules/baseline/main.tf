terraform {
  required_version = ">= 0.15.5, <= 1.2.3"
}

# Create tenants Table
resource "aws_dynamodb_table" "tenants" {
  name = "tenants"
  hash_key = "tenantId"

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
  name = "auth-info"
  hash_key = "tenantPath"

  attribute {
    name = "tenantPath"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}

# Create silo-config table
resource "aws_dynamodb_table" "silo_config" {
  name = "silo-config"
  hash_key = "tenantName"

  attribute {
    name = "tenantName"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}