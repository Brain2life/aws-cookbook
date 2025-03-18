output "bastion_host_id" {
  description = "EC2 instance ID of the Bastion Host"
  value       = module.ec2-bastion-server.instance_id
}

output "bastion_host_public_ip" {
  description = "Public IP address of Bastion host"
  value       = module.ec2-bastion-server.public_ip
}

output "db_instance_endpoint" {
  description = "The DB instance connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_master_user_secret_arn" {
  description = "The ARN of the master user secret DB"
  value       = module.db.db_instance_master_user_secret_arn
}