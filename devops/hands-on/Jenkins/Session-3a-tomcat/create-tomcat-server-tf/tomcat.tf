//This Terraform config file creates 2 Tomcat Server (Stage and Production) on EC2 Instance. Applicable in N. Virginia(us-east-1).

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "tomcat-server" {
  ami           = var.myami
  instance_type = var.instancetype
  key_name      = var.mykey
  count = 2
  vpc_security_group_ids = [aws_security_group.tf-tomcat-sec-gr.id]
  user_data = file("userdata.sh")
  tags = {
    Name = "tomcat-${element(var.tags, count.index)}"
  }

}

resource "aws_security_group" "tf-tomcat-sec-gr" {
  name = var.secgrname
  tags = {
    Name = var.secgrname
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "tomcatserverspublicip" {
  value = aws_instance.tomcat-server.*.public_dns
}

# resource "null_resource" "prod-tomcat-cfg2" {
#   connection {
#     host = aws_instance.tomcat-server[1].public_ip
#     type = "ssh"
#     user = "ec2-user"
#     private_key = file("~/.ssh/${var.mykey}.pem")
#     # Do not forget to define your key file path correctly!
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod 777 /opt/tomcat/conf/tomcat-users.xml",
#       "sudo chmod 777 /opt/tomcat/webapps/host-manager/META-INF/context.xml",
#       "sudo chmod 777 /opt/tomcat/webapps/manager/META-INF/context.xml",
#       "sudo chmod 777 /etc/systemd/system"
#     ]
#   }

#   provisioner "file" {
#     source = "./tomcat-users.xml"
#     destination = "/opt/tomcat/conf/tomcat-users.xml"
#   }

#   provisioner "file" {
#     source = "./contexthost-mng.xml"
#     destination = "/opt/tomcat/webapps/host-manager/META-INF/context.xml"
#   }

#   provisioner "file" {
#     source = "./contextmng.xml"
#     destination = "/opt/tomcat/webapps/manager/META-INF/context.xml"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo /opt/tomcat/bin/shutdown.sh",
#       "sudo /opt/tomcat/bin/startup.sh"
#     ]
#   }

#   provisioner "file" {
#     source = "./tomcat.service"
#     destination = "/etc/systemd/system/tomcat.service"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo systemctl daemon-reload",
#       "sudo systemctl enable tomcat",
#       "sudo systemctl start tomcat"
#     ]
#   }

# }