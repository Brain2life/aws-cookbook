output "bedrock_role_arn" {
  description = "The ARN of the IAM role for Bedrock access."
  value       = aws_iam_role.bedrock_role.arn
}

output "bedrock_role_name" {
  description = "The name of the IAM role for Bedrock."
  value       = aws_iam_role.bedrock_role.name
}

output "bedrock_assume_role_policy_arn" {
  description = "The ARN of the policy that grants assume-role permissions for Bedrock IAM Role."
  value       = aws_iam_policy.bedrock_assume_role_policy.arn
}

output "bedrock_iam_user_name" {
  description = "The name of the IAM user that can assume the Bedrock role."
  value       = data.aws_iam_user.bedrock_user.user_name
}