provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [var.tagName]
  }
}