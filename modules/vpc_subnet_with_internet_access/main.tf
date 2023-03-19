# Setting up the VPC
resource "aws_vpc" "ecs_network" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    origin = "dragondrop-compute-module"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ecs_network.id

  tags = {
    origin = "dragondrop-compute-module"
  }
}

# Creating a Public Subnet with access to the internet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ecs_network.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    origin = "dragondrop-compute-module"
    name   = "ecs fargate subnet"
  }
}

# Routes definition
resource "aws_route_table" "public_subnets_route_table" {
  vpc_id = aws_vpc.ecs_network.id

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_internet_gateway.internet_gateway
  }

  tags = {
    origin = "dragondrop-compute-module"
    name   = "ecs fargate routes table"
  }
}

# Add Security Group + Rules
resource "aws_security_group" "ecs_fargate_sg" {
  name        = "dragondrop-compute-ecs-fargate-sg"
  description = "Allow unrestricted outbound egress"
  vpc_id      = aws_vpc.ecs_network.id

  tags = {
    "origin" : "dragondrop-compute-module"
  }
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.ecs_fargate_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
