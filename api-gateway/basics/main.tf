#################################################################################
# Lambda Module
# https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest
#################################################################################
module "my_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.20.2"

  # Basic settings
  function_name = "simple-nodejs-lambda"
  description   = "Simple NodeJS based Lambda function"
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  # Point to the Lambda function code directory. Store package locally.
  source_path = "${path.module}/lambda"

  # Publish a new version on each apply
  publish = true

  # Enable API trigger 
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.my_http_api.api_execution_arn}/*/*"
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

#################################################################################
# HTTP API Gateway Module
# https://registry.terraform.io/modules/terraform-aws-modules/apigateway-v2/aws
#################################################################################
module "my_http_api" {
  source  = "terraform-aws-modules/apigateway-v2/aws" # HTTP-API v2 module
  version = "~> 5.3.0"

  name          = "my-http-api"
  description   = "HTTP API with Lambda integration"
  protocol_type = "HTTP"

  # Disable creation of the domain name and API mapping
  create_domain_name = false

  # Disable creation of Route53 alias record(s) for the custom domain
  create_domain_records = false

  # Default “catch-all” route: proxy all requests to Lambda
  routes = {
    "$default" = {
      integration = {
        integration_type       = "AWS_PROXY"
        uri                    = module.my_lambda_function.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
