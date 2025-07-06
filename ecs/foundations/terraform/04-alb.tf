#######################################################################
# ALB for ECS Cluster
# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws
#######################################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name               = "ecs-ui-alb"
  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb.id]

  target_groups = [
    {
      name_prefix      = "ui-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip" # required for ECS Fargate
      health_check = {
        enabled             = true
        path                = "/actuator/health"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  # Optional HTTPS listener — requires valid certificate ARN
  # https_listeners = [
  #   {
  #     port               = 443
  #     protocol           = "HTTPS"
  #     certificate_arn    = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  #     target_group_index = 0
  #   }
  # ]

  tags = local.tags
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optional: Uncomment if you're planning to enable HTTPS now or later
  # ingress {
  #   description = "Allow HTTPS from anywhere"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
