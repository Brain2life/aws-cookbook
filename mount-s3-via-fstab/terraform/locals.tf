locals {
  name = "s3-mount-demo"

  region = "us-east-1"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}