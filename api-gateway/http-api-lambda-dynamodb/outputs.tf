output "http_api_endpoint" {
  description = "API Gateway HTTP API endpoint"
  value       = module.my_http_api.api_endpoint
}

output "lambda_name" {
  description = "Lambda function name"
  value       = module.my_lambda_function.lambda_function_name
}