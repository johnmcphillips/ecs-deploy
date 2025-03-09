resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "PublicSubnet01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PublicSubnet01.cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.PublicSubnet01.name
  }
}

resource "aws_subnet" "PublicSubnet02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PublicSubnet02.cidr_block
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = var.PublicSubnet02.name
  }
}

resource "aws_subnet" "PrivateSubnet01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PrivateSubnet01.cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name = var.PrivateSubnet01.name
  }
}

resource "aws_subnet" "PrivateSubnet02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PrivateSubnet02.cidr_block
  availability_zone = "us-east-1b"
  tags = {
    Name = var.PrivateSubnet01.name
  }
}

resource "aws_eip" "NAT_EIP" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id     = aws_subnet.PublicSubnet01.id
  tags = {
    Name = "ECS Nat Gateway"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ECS Internet Gateway"
  }
}

resource "aws_route_table" "PublicRTB" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "PrivateRTB" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NGW.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "PublicAssoc01" {
  subnet_id      = aws_subnet.PublicSubnet01.id
  route_table_id = aws_route_table.PublicRTB.id
}

resource "aws_route_table_association" "PublicAssoc02" {
  subnet_id      = aws_subnet.PublicSubnet02.id
  route_table_id = aws_route_table.PublicRTB.id
}

resource "aws_route_table_association" "PrivateAssoc01" {
  subnet_id      = aws_subnet.PrivateSubnet01.id
  route_table_id = aws_route_table.PrivateRTB.id
}

resource "aws_route_table_association" "PrivateAssoc02" {
  subnet_id      = aws_subnet.PrivateSubnet02.id
  route_table_id = aws_route_table.PrivateRTB.id
}

