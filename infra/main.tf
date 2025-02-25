provider "aws" {
  region = var.aws_region
}

# Chama os outros arquivos Terraform
module "vpc" {
  source = "./vpc.tf"
}

module "eks" {
  source          = "./eks.tf"
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "ecr" {
  source = "./ecr.tf"
}

module "alb" {
  source  = "./alb.tf"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
}

module "security_groups" {
  source = "./security-groups.tf"
  vpc_id = module.vpc.vpc_id
}
