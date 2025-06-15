output "ec2_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "ssm_connect_command" {
  description = "The AWS CLI command to connect to the instance using Session Manager"
  value       = "aws ssm start-session --target ${module.ec2_instance.id} --region ${local.region}"
}

output "s3_bucket_name" {
  description = "S3 Bucket name"
  value       = module.s3_bucket.s3_bucket_id
}