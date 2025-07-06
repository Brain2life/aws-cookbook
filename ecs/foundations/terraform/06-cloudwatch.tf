# Create CloudWatch Log Group for ECS logs
resource "aws_cloudwatch_log_group" "retail_store_ui" {
  name              = "retail-store-ecs-tasks"
  retention_in_days = 1

  tags = local.tags
}
