########################################################################################## 
# SG for EC2 iterraform-aws-modules/security-group/awsnstance
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
########################################################################################## 
module "security_group_instance" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3.0"

  name        = "${local.name}-ec2"
  description = "Security Group for EC2 Instance Egress"

  vpc_id = module.vpc.vpc_id

  egress_rules = ["all-all"] # Allow all traffic
  # egress_rules = ["https-443-tcp"] # You can restrict egress rules

  tags = local.tags
}
