module "tf-vpc" {
  source = "../modules"
  environment = "QA"
  vpc_cidr_block = "10.3.0.0/16"
  public_subnet_cidr = "10.3.1.0/24"
  private_subnet_cidr = "10.3.2.0/24"
  mykey = "oliver"
  instancetype = "t2.medium"
  myami = "ami-0dfcb1ef8550277af"
  num = 1
}

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}