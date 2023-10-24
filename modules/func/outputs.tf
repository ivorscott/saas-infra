output "lambda_function_arn" {
  value = aws_lambda_function.function.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.function.function_name
}
