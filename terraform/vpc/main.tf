provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      Name = "Kul"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.vpc_id
  tags = {
    "Name" = "Kul"
  }
}