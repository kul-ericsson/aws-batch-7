output "vpc_id"{
    value = data.aws_vpc.vpc.id
}
output "subnet_ids" {
  value = data.aws_subnet_ids.sn_ids.ids
}
output "ec2_private_ips" {
  value = {
      for id in (data.aws_subnet_ids.sn_ids.ids) : id => aws_instance.ec2[id].private_ip
  }
}
output "ec2_public_ips" {
  value = {
      for id in (data.aws_subnet_ids.sn_ids.ids) : id => aws_instance.ec2[id].public_ip
  }
}
output "ebs_ids" {
  value = {
      for id in (data.aws_subnet_ids.sn_ids.ids) : id => aws_ebs_volume.ebs[id].id
  }
}
