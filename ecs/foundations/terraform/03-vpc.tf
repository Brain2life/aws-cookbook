############################################################################## 
# VPC for ECS Cluster
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
##############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "ecs-vpc"
  cidr = "10.0.0.0/16"

  azs                  = ["us-east-1c", "us-east-1d"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.101.0/24", "10.0.102.0/24"] # Use private subnets for running private Fargate tasks in awsvpc mode
  enable_nat_gateway   = true
  single_nat_gateway   = true # Use one NAT Gateway for cost-saving
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}
