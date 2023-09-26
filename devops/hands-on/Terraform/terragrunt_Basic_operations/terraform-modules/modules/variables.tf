variable "environment" {
  default = "clarusway"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "this is our vpc cidr block"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  description = "this is our public subnet cidr block"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
  description = "this is our private subnet cidr block"
}

variable "mykey" {
  default = "oliver"
  description = "this is my key pair"
}

variable "instancetype" {
  default = "t2.micro"
  description = "default free tier instance type"
}

variable "myami" {
  default = "ami-0dfcb1ef8550277af"
  description = "ami of the amazon linux 2 instance"
}

variable "num" {
  default = 1
  description = "number of ec2 instances"
}