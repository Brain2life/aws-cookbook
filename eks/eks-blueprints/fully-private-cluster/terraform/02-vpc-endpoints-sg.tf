##########################################################################################
# Security Group for VPC Endpoints
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/4.17.2
########################################################################################## 
module "vpc_endpoints_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-vpc-endpoints"
  description = "Security group for VPC endpoint access"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "VPC CIDR HTTPS"
      cidr_blocks = join(",", module.vpc.private_subnets_cidr_blocks)
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "All egress HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}