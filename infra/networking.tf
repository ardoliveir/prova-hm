# =========================================
# VPC Module Configuration
# =========================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  # VPC basic settings
  name = var.vpc_name
  cidr = var.vpc_cidr

  # Subnet configuration
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # Enable or disable NAT Gateway
  enable_nat_gateway = var.nat_gateway

  # Apply default tags
  tags = var.additional_tags

  # Tags for public and private subnets
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}
