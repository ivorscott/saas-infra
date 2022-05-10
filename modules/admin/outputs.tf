output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "issuer" {
  value = aws_cognito_user_pool.pool.endpoint
}