provider "aws" {
  region = "us-east-2"
}

variable "tagName" {
  Description = "Type your Name to be used as TAGNAME for resources"
  type = String
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
  vpc_id = aws_vpc.vpc.vpc_id
  tags = {
    "Name" = var.tagName
  }
}