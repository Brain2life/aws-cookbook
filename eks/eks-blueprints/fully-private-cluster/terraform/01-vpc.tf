############################################################################## 
# VPC for Private EKS Cluster
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest 
##############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.21.0"

  name = "vpc-for-${local.name}"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  # Disable NAT Gateway creation (private subnets will not have internet access)
  enable_nat_gateway = false

  # Tag private subnets so Kubernetes knows they are for internal load balancers
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}