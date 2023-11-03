terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  #profile = "cw-training"

}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "elk" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
  key_name = "aduncan"
  vpc_security_group_ids = [aws_security_group.elk-sg.id]
  root_block_device {
    volume_size = 16
  }
  tags = {
    Name = "elk-server-aduncan"
  }
}

resource "aws_security_group" "elk-sg" {
  name = "elk-server-sec-gr"
  tags = {
    Name = "elk-server-sec-gr-aduncan"
  }

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5601
    protocol  = "tcp"
    to_port   = 5601
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elk-server-aduncan-DNS" {
  value = aws_instance.elk.public_ip
}