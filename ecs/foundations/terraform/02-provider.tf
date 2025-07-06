provider "aws" {
  region = local.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0" # Pin the latest version in 5.x.x before breaking changes in v6.x.x
    }
  }
}