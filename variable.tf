variable "vpc_name" {
  type = string
  description = "DevOps project"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR for VPC"
}

variable "public_subnet" {
  type = list(string)
  description = "public subnet CIDR values"  
}

# variable "private_subnet" {
#   type = list(string)
#   description = "private subnet CIDR values" 
# }

variable "ec2_sg_name" {
  type = string
  description = "Enable the Port 22(SSH) & Port 80(http)"
}

variable "ec2_ami_id" {
  type = string
  description = "AMI id for ec2 instance"
}

variable "public_key" {
  type = string
  description = "public key for ec2 instances"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}