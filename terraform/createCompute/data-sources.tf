data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [var.dataTagName]
  }
}

data "aws_subnet_ids" "sn_ids" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet_ids" "public_sn_id"{
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Name"
    values = ["kul_public"]
  }
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.vpc.id
  availability_zone = "us-east-2a"
}
data "aws_subnet" "private_1" {
  vpc_id = data.aws_vpc.vpc.id
  availability_zone = "us-east-2b"
}
data "aws_subnet" "private_2" {
  vpc_id = data.aws_vpc.vpc.id
  availability_zone = "us-east-2c"
}