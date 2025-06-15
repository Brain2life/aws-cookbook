############################################################################# 
# VPC Endpoints for SSM
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.21.0
#############################################################################
module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id = module.vpc.vpc_id

  endpoints = { for service in toset(["ssm", "ssmmessages", "ec2messages"]) :
    replace(service, ".", "_") =>
    {
      service             = service
      subnet_ids          = module.vpc.public_subnets
      private_dns_enabled = true
      tags                = { Name = "${local.name}-${service}" }
    }
  }

  create_security_group      = true
  security_group_name_prefix = "${local.name}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from subnets"
      cidr_blocks = module.vpc.public_subnets_cidr_blocks
    }
  }


  tags = local.tags

}
