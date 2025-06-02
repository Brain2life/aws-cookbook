##############################################################################
# VPC for EKS
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
##############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19.0"

  name = "custom-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  # Tags to apply to public subnets
  public_subnet_tags = {
    # Required by AWS Load Balancer Controller and EKS to place public-facing ELBs here
    "kubernetes.io/role/elb" = 1
  }

  # Tags to apply to private subnets
  private_subnet_tags = {
    # Required by AWS Load Balancer Controller and EKS to place internal (private) ELBs here
    "kubernetes.io/role/internal-elb" = 1

    # Enables Karpenter to automatically discover and use these subnets for provisioning worker nodes
    "karpenter.sh/discovery" = local.cluster_name
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}