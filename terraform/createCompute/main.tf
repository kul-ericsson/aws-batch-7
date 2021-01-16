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
  ingress {
    description = "MYSQL Port"
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_blocks = ["10.10.0.0/16"]
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
      private_key = file(var.keyPath)
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

resource "aws_db_subnet_group" "db_sg" {
  name = var.tagName
  subnet_ids = [ data.aws_subnet.public.id, data.aws_subnet.private_1.id, data.aws_subnet.private_2.id ]
}

resource "aws_db_instance" "rds" {
  engine = "mysql"
  engine_version = "8.0.20"
  instance_class = "db.t2.micro"
  identifier = var.tagName
  storage_type = "gp2"
  allocated_storage = 10
  db_subnet_group_name = aws_db_subnet_group.db_sg.id
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  name = var.tagName
  username = "admin"
  password = "admin123"
  skip_final_snapshot = true
}
