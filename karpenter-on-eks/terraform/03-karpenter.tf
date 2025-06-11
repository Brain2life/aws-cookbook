################################################################################################### 
# Karpenter Module
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest/submodules/karpenter
################################################################################################### 
module "eks_karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.36.0"

  cluster_name = module.eks.cluster_name

  # Enables IAM permissions required for Karpenter v1.x+
  # Set to `false` if using legacy versions (v0.33.x to v0.37.x)
  enable_v1_permissions = true

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = local.karpenter_node_iam_role
  create_pod_identity_association = true

  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}