provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.12.0"

  name               = var.vpc_name
  cidr               = local.vpc_cir_block
  azs                = local.availability_zones
  private_subnets    = local.private_subnets_cidr_az_mapping
  public_subnets     = local.public_subnets_cidr_az_mapping
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.resource_tags
}

data "aws_availability_zones" "available" {}

locals {
  vpc_cir_block = "192.168.0.0/16"

  availability_zones             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets_cidr_az_mapping = [
    "192.168.10.0/24",
    "192.168.20.0/24",
    "192.168.30.0/24"
  ]

  private_subnets_cidr_az_mapping = [
    "192.168.40.0/24",
    "192.168.50.0/24",
    "192.168.60.0/24"
  ]

  resource_tags = {
    "ManagedBy" : "Terraform"
  }
}
