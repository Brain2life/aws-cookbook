############################################################################## 
# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest 
##############################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  create_igw = true # Create IGW and related route tables for public subnets

  azs            = ["us-east-1a"]
  public_subnets = ["10.0.101.0/24"]

  tags = local.tags

}