##########################################################
# EKS Cluster with Managed Node Groups
##########################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.35.0"

  cluster_name    = "prod"
  cluster_version = "1.32" # Kubernetes version

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    standard-workers = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 3
      max_size     = 4
      desired_size = 3
    }
  }

  # Allow Agones traffic
  node_security_group_additional_rules = {
    allow_udp_agones = {
      type        = "ingress"
      protocol    = "udp"
      from_port   = 7000
      to_port     = 8000
      cidr_blocks = ["95.58.29.194/32"] # restrict to your CIDR or IP address
      description = "Allow UDP traffic for Agones game servers"
      # security_group_id is handled internally by the module
    }
  }


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}