# =========================================
# AWS Configuration
# =========================================

variable "aws_region" {
  description = "AWS Region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "aws_account" {
  description = "AWS Account ID"
  type        = string
  default     = "715841332943"
}

# =========================================
# EKS Cluster Configuration
# =========================================

variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "app-cluster"
}

variable "eks_version" {
  description = "EKS version"
  type        = string
  default     = "1.29"
}

# =========================================
# Node Group Configuration
# =========================================

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
  default     = "eks-node-group"
}

variable "worker_instance_type" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "ami" {
  description = "Amazon Machine Image (AMI) for worker nodes"
  type        = string
  default     = "AL2_x86_64"
}

# =========================================
# Networking Configuration
# =========================================

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "prd-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of AWS Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Public Subnets
variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_names" {
  description = "Explicit names for public subnets"
  type        = list(string)
  default     = ["public-subnet-1", "public-subnet-2"]
}

variable "public_subnet_suffix" {
  description = "Suffix appended to public subnet names"
  type        = string
  default     = "public"
}

variable "public_subnet_tags" {
  description = "Tags for public subnets (e.g., for ELB usage)"
  type        = map(string)
  default = {
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets
variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_tags" {
  description = "Tags for private subnets (e.g., for internal ELB usage)"
  type        = map(string)
  default = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# NAT Gateway
variable "nat_gateway" {
  description = "Enable or disable NAT Gateway (true/false)"
  type        = string
  default     = "true"
}

# =========================================
# AWS Load Balancer Controller Configuration
# =========================================

variable "aws_load_balancer_controller_config" {
  description = "Configuration for AWS Load Balancer Controller Helm chart"
  type        = map(string)
  default = {
    serviceAccountCreate = "false"
    serviceAccountName   = "aws-load-balancer-controller"
    region               = "us-east-1"
    enableCertManager    = "false"
    replicaCount         = "1"
  }
}

# =========================================
# Default Tags for Resources
# =========================================

variable "additional_tags" {
  description = "Default tags applied to AWS resources"
  type        = map(string)
  default = {
    Project   = "hotmart"
    Owner     = "Anderson Oliveira"
    terraform = "True"
  }
}
