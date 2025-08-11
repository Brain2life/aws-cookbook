output "subnet_ids" {
  description = "All subnets in the VPC (Subnet01, Subnet02, optional Subnet03)"
  value = concat(
    [aws_subnet.subnet01.id, aws_subnet.subnet02.id],
    local.has_third_subnet ? [aws_subnet.subnet03[0].id] : []
  )
}

output "security_group_id" {
  description = "Security group for cluster control plane communication with worker nodes"
  value       = aws_security_group.control_plane.id
}

output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.this.id
}
