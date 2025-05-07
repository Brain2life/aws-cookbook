output "lambda_arn" {
  description = "ARN value of Lambda function"
  value       = module.my_lambda_function.lambda_function_arn
}

output "lambda_name" {
  description = "Lambda function name"
  value       = module.my_lambda_function.lambda_function_name
}

output "http_api_endpoint" {
  description = "Invoke any route via this URL"
  value       = module.my_http_api.api_endpoint
}