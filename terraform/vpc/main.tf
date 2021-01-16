provider "aws" {
  region = "us-east-2"
}

variable "tagName" {
  description = "Type your Name to be used as TAGNAME for resources"
  type = string
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      Name = var.tagName
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = var.tagName
  }
}

resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.tagName}_igw"
  }
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "sn_public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.10.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.tagName}_public"
  }
}

resource "aws_route_table_association" "igw_rta" {
  subnet_id = aws_subnet.sn_public.id
  route_table_id = aws_route_table.igw_rt.id
}

resource "aws_subnet" "sn_private_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.20.0/24"
  availability_zone = "us-east-2b"
  tags = {
    "Name" = "${var.tagName}_private"
  }
}

resource "aws_subnet" "sn_private_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.30.0/24"
  availability_zone = "us-east-2c"
  tags = {
    "Name" = "${var.tagName}_private"
  }
}

# Resources to Create NAT Gateway
resource "aws_eip" "eip" {
  tags = {
    "Name" = var.tagName
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.sn_public.id
  tags = {
    "Name" = var.tagName
  }
}

