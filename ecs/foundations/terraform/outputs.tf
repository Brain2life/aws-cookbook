# Application Load Balancer Security Group ID
output "alb_security_group_id" {
  value = aws_security_group.alb.id
}