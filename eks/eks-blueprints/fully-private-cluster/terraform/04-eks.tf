################################################################################
# EKS Cluster
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/20.11.1
################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11"

  cluster_name    = local.name
  cluster_version = "1.31"

  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_endpoint_private_access = true  # The API endpoint is accessible from within the VPC.
  cluster_endpoint_public_access  = false # The API endpoint is NOT accessible from the public internet.

  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    workers = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 5
      desired_size = 3
    }
  }

  tags = local.tags
}