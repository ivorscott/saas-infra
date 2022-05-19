terraform {
  required_version = ">= 0.15.5, <= 1.1.9"
}

# Create Tenant Table
resource "aws_dynamodb_table" "tenant" {
  name = "Tenant-${var.stage}"
  hash_key = "tenant_id"

  attribute {
    name = "tenant_id"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}

# Create AuthInfo Table
resource "aws_dynamodb_table" "auth_info" {
  name = "AuthInfo-${var.stage}"
  hash_key = "tenant_path"

  attribute {
    name = "tenant_path"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}

# Create Metadata Table
resource "aws_dynamodb_table" "metadata" {
  name = "Metadata-${var.stage}"
  hash_key = "name"

  attribute {
    name = "name"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}


# Create Tenant Mapping Table
resource "aws_dynamodb_table" "tenant_mapping" {
  name = "Tenant-Mapping-${var.stage}"
  hash_key = "tenant_name"

  attribute {
    name = "tenant_name"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
}