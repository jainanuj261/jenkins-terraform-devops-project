variable "alb_name" {}
variable "is_external" {default = false}
variable "lb_type" {}
variable "sg_grps" {}
variable "subnet_ids" {}
variable "tag_name" {}
variable "alb-http_listener_port" {}
variable "alb-http_listener_protocol" {}
variable "alb-http_listener_type" {}
variable "alb_target_group_arn" {}

resource "aws_lb" "devops-prj_alb" {
  name = var.alb_name
  internal = var.is_external
  load_balancer_type = var.lb_type
  security_groups = [var.sg_grps]
  subnets = var.subnet_ids
  tags = {
    Name = var.tag_name
  }
}

resource "aws_lb_listener" "devops-prj-alb-http_listener" {
  load_balancer_arn = aws_lb.devops-prj_alb.arn
  port = var.alb-http_listener_port
  protocol = var.alb-http_listener_protocol
  default_action {
    type = var.alb-http_listener_type
    target_group_arn = var.alb_target_group_arn
  }
}