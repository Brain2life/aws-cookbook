###########################################################################################################################
# IAM role for the EBS CSI controller (IRSA)
#   - Trusts the cluster OIDC
#   - Scoped to the SA: kube-system/ebs-csi-controller-sa
#   - Uses AWS-managed policy: AmazonEBSCSIDriverPolicy
# For more information, see https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEBSCSIDriverPolicy.html
###########################################################################################################################

# Define Trust Policy for EBS CSI IAM Role
data "aws_iam_policy_document" "ebs_csi_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

# Create IAM role for EBS CSI Service Account
resource "aws_iam_role" "ebs_csi_controller" {
  name               = "eks-ebs-csi-controller-${module.eks.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_trust.json
  description        = "IRSA role for EBS CSI controller on ${module.eks.cluster_name}"
}

# Attach AWS Managed Policy
resource "aws_iam_role_policy_attachment" "ebs_csi_managed_policy" {
  role       = aws_iam_role.ebs_csi_controller.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# (Optional) make addon creation wait for the role
# The module will internally manage ordering, but this can help:
resource "null_resource" "ebs_csi_role_ready" {
  depends_on = [aws_iam_role_policy_attachment.ebs_csi_managed_policy]
}