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

resource "aws_launch_template" "serverAutoScale" {
  image_id = "ami-0a8bcde34acb334ab"
  # SUSE Linux Enterprise Server 15 SP4 64-bit
  instance_type = var.instancia
  vpc_security_group_ids = [ aws_security_group.a290223-sc.id ]
  # security_group_names <- search differences
  key_name = var.chave
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
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.chave
  public_key = file("${var.chave}.pub")
}

