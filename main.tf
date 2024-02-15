provider "aws" {
  region = "ap-south-1"
}

module "networking" {
  source = "./infra/networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  public_subnet = var.public_subnet
  # private_subnet = var.private_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "security_group" {
  source = "./infra/security-groups"
  vpc_id = module.networking.vpc_id
  ec2_sg_name = var.ec2_sg_name
}

module "jenkins-ec2" {
  source = "./infra/jenkins-ec2"
  public_key = var.public_key
  instance_type = "t2.medium"
  key_name = "jenkins"
  subnet_id = tolist(module.networking.public_subnet_id)[0]
  ec2_sg_name = [module.security_group.security_group_id]
  tag_name = "Jenkins:Ubuntu Linux EC2"
  ami_id = var.ec2_ami_id
  enable_public_ip_addrs = true
  user_data_install_jenkins = templatefile("./infra/jenkins_installer/jenkins_installer.sh",{})
}

module "lb_target_group_and_attachment" {
  source = "./infra/lb-target-grp"
  vpc_id = module.networking.vpc_id
  lb_target_group_port = 8080
  lb_target_group_protocol = "HTTP"
  lb_target_group_name = "jenkins-lb-target-group"
  ec2_instance_id = module.jenkins-ec2.ec2_jenkins_id
  target_grp_attachment_port = 8080
}

module "alb" {
  source = "./infra/load-balancer"
  lb_type = "application"
  subnet_ids = tolist(module.networking.public_subnet_id)
  sg_grps = module.security_group.security_group_id
  alb_name = "devops-prj-alb"
  tag_name = "devops-prj-alb"
  is_external = false
  alb-http_listener_port = 80
  alb-http_listener_protocol = "HTTP"
  alb-http_listener_type = "forward"
  alb_target_group_arn = module.lb_target_group_and_attachment.devops-prj-target_grp_arn
}