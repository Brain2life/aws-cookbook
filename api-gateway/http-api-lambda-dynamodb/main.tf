#################################################################################
# DynamoDB Module
# https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws/latest
#################################################################################
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 4.3.0"


  name         = "http-crud-tutorial-items" # Table name 
  hash_key     = "id"                       # Partition key
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "id"
      type = "S" # String type
    }
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

#################################################################################
# Lambda Module
# https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest
#################################################################################
module "my_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.20.2"

  # Basic settings
  function_name = "http-crud-tutorial-function"
  description   = "Lambda function for HTTP CRUD tutorial"
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  # Point to the Lambda function code directory. Store package locally.
  source_path = "${path.module}/src"

  # Publish a new version on each apply
  publish = true

  environment_variables = {
    TABLE_NAME = "http-crud-tutorial-items"
  }

  attach_policy_statements = true
  policy_statements = [
    {
      actions   = ["dynamodb:*"]
      resources = ["*"] # For demo only; In production limit to the table ARN and avoid '*' permissive options. Follow least privilege principle. 
    }
  ]

  create_role = true
  role_name   = "http-crud-tutorial-role"

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

  name          = "http-crud-tutorial-api"
  description   = "HTTP API Gateway for CRUD Lambda"
  protocol_type = "HTTP"

  # Disable creation of the domain name and API mapping
  create_domain_name = false

  # Disable creation of Route53 alias record(s) for the custom domain
  create_domain_records = false

  # Default “catch-all” route: proxy all requests to Lambda
  routes = {
    "GET /items/{id}" = {
      integration = {
        uri                    = module.my_lambda_function.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
    "GET /items" = {
      integration = {
        uri                    = module.my_lambda_function.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
    "PUT /items" = {
      integration = {
        uri                    = module.my_lambda_function.lambda_function_arn
        payload_format_version = "2.0"
      }
    }
    "DELETE /items/{id}" = {
      integration = {
        uri                    = module.my_lambda_function.lambda_function_arn
        payload_format_version = "2.0"
      }
    }

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
