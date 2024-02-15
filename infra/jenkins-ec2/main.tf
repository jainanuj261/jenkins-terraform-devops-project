variable "ami_id" {}
variable "instance_type" {}
variable "ec2_sg_name" {}
variable "subnet_id" {}
variable "enable_public_ip_addrs" {}
variable "user_data_install_jenkins" {}
variable "key_name" {}
variable "tag_name" {}
variable "public_key" {}

output "ec2_jenkins_id" {
  value = aws_instance.ec2_jenkins.id
}

resource "aws_instance" "ec2_jenkins" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.ec2_sg_name
  associate_public_ip_address = var.enable_public_ip_addrs
  user_data = var.user_data_install_jenkins
  key_name = var.key_name
  tags = {
    Name = var.tag_name
  }
}

resource "aws_key_pair" "ec2_instance_public_key" {
  key_name = var.key_name
  public_key = var.public_key
}