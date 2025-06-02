output "oidc_provider_url" {
  description = "OIDC provider URL without https://"
  value       = module.eks.oidc_provider
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "karpenter_controller_iam_role" {
  description = "The name of the controller IAM role"
  value       = module.eks_karpenter.iam_role_name
}

output "karpenter_node_iam_role" {
  description = "The name of the node IAM role"
  value       = module.eks_karpenter.node_iam_role_name
}

output "karpenter_sqs_queue" {
  description = "The name of the created Amazon SQS queue"
  value       = module.eks_karpenter.queue_name
}
