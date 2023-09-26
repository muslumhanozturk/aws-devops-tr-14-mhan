module "tf-vpc" {
  source = "../modules"
  environment = "DEV"
  vpc_cidr_block = "10.1.0.0/16"
  public_subnet_cidr = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
  mykey = "oliver"
  instancetype = "t2.micro"
  myami = "ami-0dfcb1ef8550277af"
  num = 1
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}