variable "vpc_name" {}
variable "vpc_cidr" {}
# variable "private_subnet" {}
variable "eu_availability_zone" {}
variable "public_subnet" {}

output "vpc_id" {
  value = aws_vpc.Terraform_VPC.id
}

output "public_subnet_id" {
  value = aws_subnet.devops-prj-vpc_public_subnets.*.id
}

resource "aws_vpc" "Terraform_VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# set up for private subnet
# resource "aws_subnet" "devops-prj-vpc_private_subnets" {
#   count = length(var.private_subnet)  
#   vpc_id = aws_vpc.Terraform_VPC.id
#   cidr_block = element(var.private_subnet,count.index)
#   tags = {
#     Name = "devops-prj-private-subnet-${count.index + 1}"
#   }  
# }

# set up for public subnet
resource "aws_subnet" "devops-prj-vpc_public_subnets" {
  count = length(var.public_subnet)  
  vpc_id = aws_vpc.Terraform_VPC.id
  cidr_block = element(var.public_subnet,count.index)
  availability_zone = element(var.eu_availability_zone, count.index)
  tags = {
    Name = "devops-prj-public-subnet-${count.index + 1}"
  }
}

# set up for igw
resource "aws_internet_gateway" "devops-prj-vpc_public_igw" {
  vpc_id = aws_vpc.Terraform_VPC.id
  tags = {
    Name = "devops-prj-igw"
  }
}

# public route table
resource "aws_route_table" "devops-prj-public_route_table" {
  vpc_id = aws_vpc.Terraform_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-prj-vpc_public_igw.id
  }
  tags = {
    Name = "devops-prj-public-rt"
  }
}

# # private route table
# resource "aws_route_table" "devops-prj-private_route_table" {
#   vpc_id = aws_vpc.Terraform_VPC.id
#   tags = {
#     Name = "devops-prj-private-rt"
#   }
# }

# public route table association
resource "aws_route_table_association" "devops-prj-public_route_table_association" {
  count = length(aws_subnet.devops-prj-vpc_public_subnets)
  subnet_id = aws_subnet.devops-prj-vpc_public_subnets[count.index].id
  route_table_id = aws_route_table.devops-prj-public_route_table.id
}

# private route table association
# resource "aws_route_table_association" "devops-prj-private_route_table_association" {
#   count = length(aws_subnet.devops-prj-vpc_private_subnets)
#   subnet_id = aws_subnet.devops-prj-vpc_private_subnets[count.index].id
#   route_table_id = aws_route_table.devops-prj-private_route_table.id
# }