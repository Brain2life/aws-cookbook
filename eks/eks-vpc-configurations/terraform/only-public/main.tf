######################################
# VPC + IGW
######################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-VPC"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-igw"
  }
}

##############################################
# Single Route Table for all public subnets
##############################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name    = "Public Subnets"
    Network = "Public"
  }
}

# 0.0.0.0/0 via IGW
resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

##############################################
# Public Subnets (01, 02, optional 03)
##############################################
resource "aws_subnet" "subnet01" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_01_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.name}-Subnet01"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "subnet02" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_02_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.name}-Subnet02"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "subnet03" {
  count                   = local.has_third_subnet ? 1 : 0 # Create third subnet if region has more than 2AZs
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_03_cidr
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.name}-Subnet03"
    "kubernetes.io/role/elb" = "1"
  }
}

################################################################
# Route Table Associations
################################################################
resource "aws_route_table_association" "subnet01" {
  subnet_id      = aws_subnet.subnet01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet02" {
  subnet_id      = aws_subnet.subnet02.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet03" {
  count          = local.has_third_subnet ? 1 : 0
  subnet_id      = aws_subnet.subnet03[0].id
  route_table_id = aws_route_table.public.id
}

#############################################################
# Security Group (Control plane SG analog)
#############################################################
resource "aws_security_group" "control_plane" {
  name        = "${var.name}-control-plane-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

  # CFN didn't add rules; default allow-all egress here
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-control-plane-sg"
  }
}
