terraform {
required_version = ">= 10.0.10"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1", "us-east-1", "us-east-1"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "bastion" {
  ami       = "ami-0234238423848234"
  instance_type      = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]

}

resource "null_resource" "dummy" {
  provisioner "local-exec" {
    command = "echo ${resource.aws_instance.bastion.public_ip}\n"
  }
}