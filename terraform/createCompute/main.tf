provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "ec2" {
  for_each = data.aws_subnet_ids.sn_ids.ids
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  key_name = "kul-ericsson-thinknyx"
  subnet_id = each.value
  tags = {
    "Name" = var.tagName
  }
}

resource "aws_security_group" "sg" {
  vpc_id = data.aws_vpc.vpc.id
  description = "Managed by Terraform"
  name = "${var.tagName}"
  tags = {
    "Name" = var.tagName
  }
  ingress {
    description = "SSH Port"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Outbound Access"
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
