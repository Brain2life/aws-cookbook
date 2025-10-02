# IAM / Roles
output "codedeploy_service_role_arn" {
  description = "IAM role ARN used by CodeDeploy (service role)"
  value       = aws_iam_role.codedeploy_service_role.arn
}

output "ec2_instance_role_arn" {
  description = "IAM role ARN assumed by EC2 instances (agent, SSM, logs, etc.)"
  value       = aws_iam_role.ec2_instance_role.arn
}

output "ec2_instance_profile_name" {
  description = "Instance profile name attached to the ASG/Launch Template"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}
