variable "ec2_sg_name" {}
variable "vpc_id" {}

output "security_group_id" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

resource "aws_security_group" "ec2_sg_ssh_http" {
  vpc_id = var.vpc_id
  name = var.ec2_sg_name

  ingress {
    description = "Allow remote ssh from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    description = "Allow HTTP from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  ingress {
    description = "Allow HTTP Jenkins from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
  
  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = var.ec2_sg_name
  }

}