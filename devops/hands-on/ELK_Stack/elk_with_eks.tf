terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux2" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10*"]
  }
}

resource "aws_instance" "elk" {
  ami = data.aws_ami.amazon_linux2.id
  instance_type = "t2.small"
  key_name = "aduncan"
  vpc_security_group_ids = [aws_security_group.elk-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  root_block_device {
    volume_size = 16
  }
  tags = {
    Name = "elk-server-aduncan"
  }
}

resource "aws_iam_role" "aws_access" {
  name = "awsrole-elk-aduncan"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "elk-server-profile-aduncan"
  role = aws_iam_role.aws_access.name
}


resource "aws_security_group" "elk-sg" {
  name = "elk-in-eks-sec-gr-aduncan"
  tags = {
    Name = "elk-in-eks-sec-gr-aduncan"
  }

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
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