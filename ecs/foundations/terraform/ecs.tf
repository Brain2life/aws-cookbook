############################################################################## 
# ECS Cluster
# https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest
############################################################################## 
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.12.1"

  # ECS Cluster name (provided from local variable)
  cluster_name = local.ecs_cluster_name

  # Enable CloudWatch Container Insights for better observability
  cluster_settings = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]

  # Define Fargate as the capacity provider with 100% weight
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  # ECS services configuration
  services = {
    # Define a service named 'retail-store-ui'
    retail-store-ui = {
      # Desired number of running tasks
      desired_count = 2

      # Task-level CPU and memory
      cpu    = 1024
      memory = 2048

      # Container configuration for the service
      container_definitions = {
        application = {
          # Docker image to use
          image     = "public.ecr.aws/aws-containers/retail-store-sample-ui:0.7.0"
          essential = true

          # Expose container port 8080 over TCP
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
              name          = "application"
            }
          ]

          # Enable init process for better container lifecycle handling
          linux_parameters = {
            initProcessEnabled = true
          }

          # Optional: Set environment variable for banner message
          # environment = [
          #   {
          #     name  = "RETAIL_UI_BANNER"
          #     value = "We've updated the UI service!"
          #   }
          # ]

          # Define a health check to monitor container status
          health_check = {
            command     = ["CMD-SHELL", "curl -f http://localhost:8080/actuator/health || exit 1"]
            interval    = 10
            timeout     = 5
            retries     = 3
            startPeriod = 60
          }

          # Configure CloudWatch logging
          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = "retail-store-ecs-tasks"
              awslogs-region        = "us-east-1"
              awslogs-stream-prefix = "ui-service"
            }
          }
        }
      }

      # ECS service will run in private subnets
      subnet_ids       = module.vpc.private_subnets
      assign_public_ip = false

      # Attach service to ALB target group on port 8080
      load_balancer = {
        service = {
          target_group_arn = module.alb.target_group_arns[0]
          container_name   = "application"
          container_port   = 8080
        }
      }

      # Define security group rules for the ECS service
      security_group_rules = {
        # Allow inbound traffic from ALB on port 8080
        alb_ingress = {
          type                     = "ingress"
          from_port                = 8080
          to_port                  = 8080
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.alb.id
        }

        # Allow all outbound traffic
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      # IAM roles for ECS task execution and container access
      execution_role_arn = aws_iam_role.ecs_execution.arn
      task_role_arn      = aws_iam_role.ecs_task.arn
    }
  }

  # Tags to apply to all ECS resources
  tags = local.tags
}
