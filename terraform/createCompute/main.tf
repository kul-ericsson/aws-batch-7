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
