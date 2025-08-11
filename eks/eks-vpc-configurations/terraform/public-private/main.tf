#######################################
# VPC + IGW
#######################################
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

########################################
# Route Tables
########################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "Public Subnets"
    Network = "Public"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "Private Subnet AZ1"
    Network = "Private01"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "Private Subnet AZ2"
    Network = "Private02"
  }
}

# Default route for public RT via IGW
resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

#########################################################
# Subnets
#########################################################
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.name}-PublicSubnet01"
    "kubernetes.io/role/elb" = "1" # Tag public subnets so Kubernetes can place load balancers into them
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.name}-PublicSubnet02"
    "kubernetes.io/role/elb" = "1" # Tag public subnets so Kubernetes can place load balancers into them
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name                              = "${var.name}-PrivateSubnet01"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name                              = "${var.name}-PrivateSubnet02"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

############################################
# EIPs + NAT Gateways (one per AZ)
############################################
resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip-a"
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip-b"
  }
}

resource "aws_nat_gateway" "a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "${var.name}-NatGatewayAZ1"
  }
}

resource "aws_nat_gateway" "b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "${var.name}-NatGatewayAZ2"
  }
}

############################################
# Private default routes via NAT
############################################
resource "aws_route" "private_a_default" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.a.id
}

resource "aws_route" "private_b_default" {
  route_table_id         = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.b.id
}

#####################################################
# Route Table Associations
#####################################################
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

#########################################################
# Security Group (Control Plane SG analog)
#########################################################
resource "aws_security_group" "control_plane" {
  name        = "${var.name}-control-plane-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

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
