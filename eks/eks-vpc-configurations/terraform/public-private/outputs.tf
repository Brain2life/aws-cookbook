output "subnet_ids" {
  description = "Subnet IDs in the VPC (public_a, public_b, private_a, private_b)"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "security_group_id" {
  description = "Security group for control plane communication with worker nodes"
  value       = aws_security_group.control_plane.id
}

output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.this.id
}
