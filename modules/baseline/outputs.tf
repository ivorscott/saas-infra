output "tenant_table_name" {
  value = aws_dynamodb_table.tenant.name
}

output "tenant_mapping_table_name" {
  value = aws_dynamodb_table.tenant_mapping.name
}

output "auth_info_table_name" {
  value = aws_dynamodb_table.auth_info.name
}

output "metadata_table_name" {
  value = aws_dynamodb_table.metadata.name
}
