# --- networking/main.tf ---

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "Demo_VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "public_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  public_subnets_cidr = [for i in range(1, 6, 2) : cidrsubnet(var.vpc_cidr_block, 8, i)]
  azs                 = data.aws_availability_zones.azs.names
}

resource "aws_subnet" "subnets" {
  count                   = length(local.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_subnets_cidr[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.azs[count.index]}"
  }
}

data "aws_subnet" "eu-north-1a" {
  filter {
    name   = "tag:Name"
    values = ["eu-north-1a"]
  }
}

resource "aws_route_table_association" "subnet_route_table_association" {
  subnet_id      = data.aws_subnet.eu-north-1a.id
  route_table_id = aws_default_route_table.public_rt.id
}

resource "aws_security_group" "sg" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}