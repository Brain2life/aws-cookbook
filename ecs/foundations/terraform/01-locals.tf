# Define commonly used values across the module
locals {
  region           = "us-east-1"
  ecs_cluster_name = "retail-store-ecs-cluster"
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}