terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.regiao_aws
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.chave
  public_key = file("${var.chave}.pub")
}

resource "aws_launch_template" "serverAutoScale" {
  image_id = "ami-0a8bcde34acb334ab"
  # SUSE Linux Enterprise Server 15 SP4 64-bit
  instance_type = var.instancia
  vpc_security_group_ids = [ aws_security_group.a290223-sc.id ]
  # security_group_names <- search differences
  key_name = var.chave
  user_data = var.desenv ? filebase64("config_script.sh") : ""
  tags = {
    Name = var.nome_instancia
  }
}

# using launch template to define instance:
#
# resource "aws_instance" "instance_launch_template"{
#    launch_template {
#      id = aws_launch_template.serverAutoScale.id
#      version = "$Latest"
#    }
# }

resource "aws_autoscaling_group" "scaleGroup" {
  name = "${var.nome_instancia}-ASGroup"
  availability_zones = [ "${var.regiao_aws}a","${var.regiao_aws}b" ]
  max_size = var.max_ec2
  min_size = var.min_ec2
  launch_template {
    id = aws_launch_template.serverAutoScale.id
    version = "$Latest"
  }
  target_group_arns = [ aws_lb_target_group.ELB_target.arn ]
}
# target_group_arns -> set of aws_alb_target_group arns for use with ALB
# defines that the resource is the target of the other

resource "aws_autoscaling_policy" "scalePolicy" {
  depends_on = [ aws_autoscaling_group.scaleGroup ]
  name = "${var.nome_instancia}-ASPolicy"
  autoscaling_group_name = "${var.nome_instancia}-ASGroup"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.regiao_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.regiao_aws}b"
}

resource "aws_default_vpc" "default" {
}

# LOAD BALANCER

resource "aws_lb" "loadBalancer" {
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.a290223-sc.id ]
  subnets = [ aws_default_subnet.subnet_1.id,aws_default_subnet.subnet_2.id ]
  tags = {
    Name = "${var.nome_instancia}-ELB"
  }
}

resource "aws_lb_target_group" "ELB_target" {
  name = "targetASGroup"
  port = "8080"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
}

resource "aws_lb_listener" "ELB_listener" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port = "8080"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ELB_target.arn
  }
}

# AUTO SCALING SCHEDULE

resource "aws_autoscaling_schedule" "daybreak" {
  scheduled_action_name = "off"
  autoscaling_group_name = aws_autoscaling_group.scaleGroup.name
  min_size = 0
  max_size = 0
  desired_capacity = 0
  start_time = timeadd(timestamp(),"6m")
  recurrence = "30 22 * * MON-FRI"
  time_zone = "Etc/GMT+3"
}

resource "aws_autoscaling_schedule" "sunrise" {
  scheduled_action_name = "on"
  autoscaling_group_name = aws_autoscaling_group.scaleGroup.name
  min_size = var.min_ec2
  max_size = var.max_ec2
  desired_capacity = var.min_ec2
  start_time = timeadd(timestamp(),"3m")
  recurrence = "30 05 * * MON-FRI"
  time_zone = "Etc/GMT+3"
}