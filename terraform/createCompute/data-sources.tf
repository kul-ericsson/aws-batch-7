data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [var.dataTagName]
  }
}

data "aws_subnet_ids" "sn_ids" {
  vpc_id = data.aws_vpc.vpc.id
}
