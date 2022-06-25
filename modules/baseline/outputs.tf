output "tenant_table_name" {
  value = aws_dynamodb_table.tenants.name
}

output "tenant_mapping_table_name" {
  value = aws_dynamodb_table.silo_config.name
}

output "auth_info_table_name" {
  value = aws_dynamodb_table.auth_info.name
}