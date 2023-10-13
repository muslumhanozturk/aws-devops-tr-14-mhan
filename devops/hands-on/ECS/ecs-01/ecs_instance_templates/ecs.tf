//This Template creates a Docker machine on EC2 Instance.
//Docker Machine will run on Amazon Linux 2023 (ami-0889a44b331db0194) EC2 Instance with
//custom security group allowing SSH connections from anywhere on port 22 and HTTP.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

locals {
  user = "cw-devops"
  pem_file = "clarusway"  # change here
}

resource "aws_instance" "ecs" {
  ami = "ami-0889a44b331db0194"
  instance_type = "t2.micro"
  key_name = local.pem_file
  vpc_security_group_ids = [aws_security_group.ecs-sec-gr.id]
  user_data = file("userdata.sh")
  tags = {
    Name = "${local.user}-ecs-instance"
  }
}

resource "aws_security_group" "ecs-sec-gr" {
  name = "ecs-lesson-sec-gr-${local.user}"
  tags = {
    Name = "ecs-lesson-sec-gr-${local.user}"
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public" {
  value = aws_instance.ecs.public_ip
}