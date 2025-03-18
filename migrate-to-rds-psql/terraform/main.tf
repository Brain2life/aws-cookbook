##########################################################
# VPC
##########################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19.0"

  name = "vpc-for-rds"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  database_subnet_group_name   = "db-subnetgroup"
  create_database_subnet_group = true
  database_subnets             = ["10.0.21.0/24", "10.0.22.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

##########################################################
# Bastion Host
##########################################################

# Call the external data source to get public IP
data "external" "my_ip" {
  program = ["bash", "./get_public_ip.sh"]
}

module "ec2-bastion-server" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "~> 0.31.1"

  name                        = "bastion-host"
  associate_public_ip_address = true
  ssm_enabled                 = true
  ami                         = "ami-0a25f237e97fa2b5e" # Ubuntu 20.04 LTS

  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id

  ebs_block_device_volume_size = 10    # Provision EBS gp2 volume of 10GB size
  ebs_delete_on_termination    = false # Do not delete EBS volume after instance termination

  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "-1"
      cidr_blocks = ["${data.external.my_ip.result.ip}/32"]
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

}
##########################################################
# Security Group for DB
##########################################################
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "postgres-db-instances"
  description = "Security Group for Postgres DB instances"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

##########################################################
# PostgreSQL
##########################################################
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.10.0"

  identifier = "postgresql"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine                   = "postgres"
  engine_version           = "17.4"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = "postgres17" # DB parameter group
  major_engine_version     = "17.4"       # DB option group
  instance_class           = "db.t4g.small"

  allocated_storage     = 10
  max_allocated_storage = 10

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "PostgresDB"
  username = "aws_user"
  port     = 5432

  # Setting manage_master_user_password_rotation to false after it
  # has previously been set to true disables automatic rotation
  # however using an initial value of false (default) does not disable
  # automatic rotation and rotation will be handled by RDS.
  # manage_master_user_password_rotation allows users to configure
  # a non-default schedule and is not meant to disable rotation
  # when initially creating / enabling the password management feature
  manage_master_user_password_rotation              = true
  master_user_password_rotate_immediately           = false
  master_user_password_rotation_schedule_expression = "rate(1 days)"

  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
