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
  vpc_security_group_ids = [ aws_security_group.sg.id ]
}

resource "aws_security_group" "sg" {
  vpc_id = data.aws_vpc.vpc.id
  description = "Managed by Terraform"
  name = var.tagName
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

resource "aws_ebs_volume" "ebs" {
  for_each = data.aws_subnet_ids.sn_ids.ids
  size = 10
  availability_zone = aws_instance.ec2[each.value].availability_zone
  tags = {
    "Name" = var.tagName
  }
}

resource "aws_volume_attachment" "volAttach" {
  for_each = data.aws_subnet_ids.sn_ids.ids
  volume_id = aws_ebs_volume.ebs[each.value].id
  instance_id = aws_instance.ec2[each.value].id
  device_name = "/dev/sdf"
  skip_destroy = true
}

resource "null_resource" "mount_vol" {
  for_each = data.aws_subnet_ids.public_sn_id.ids
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("c:/training/ericsson/aws/kul-ericsson-thinknyx.pem")
      host = aws_instance.ec2[each.value].public_ip
    }
    inline = [
      "sudo mkdir /data",
      "sudo mkfs -t ext4 /dev/xvdf",
      "sudo mount /dev/xvdf /data",
      "sudo chown ubuntu:ubuntu /data",
      "echo '[INFO] Hi I am able to mount'  >> /data/demo.txt"
    ]
  }
}
