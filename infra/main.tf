# =========================================
# Terraform Provider Requirements
# =========================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # AWS provider version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # Kubernetes provider version
    }
  }
}

# =========================================
# AWS Provider Configuration
# =========================================

provider "aws" {
  region = var.aws_region # AWS region defined in variables
}

# =========================================
# Helm Provider Configuration
# =========================================

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  }
}

# =========================================
# Kubernetes Provider Configuration
# =========================================

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}
