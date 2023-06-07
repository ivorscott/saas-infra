output "shared_user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "shared_user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}