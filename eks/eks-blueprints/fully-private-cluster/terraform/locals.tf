locals {
  region = "us-east-1"

  name = "private-eks"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Environment = "dev"
    Project     = "private-eks-demo"
    Terraform   = true
  }
}