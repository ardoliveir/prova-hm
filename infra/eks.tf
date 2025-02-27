# =========================================
# EKS Cluster Module Configuration
# =========================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  # Cluster name and version
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_version

  # Cluster access configuration
  cluster_endpoint_public_access           = true                 # Allows public access to the cluster endpoint
  enable_cluster_creator_admin_permissions = true                 # Grants admin permissions to the cluster creator
  authentication_mode                      = "API_AND_CONFIG_MAP" # Defines the cluster authentication mode

  # EKS Add-ons Configuration
  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa_ebs_csi.iam_role_arn # Associates the EBS CSI Driver role
    }
    coredns    = true # Manages DNS within the cluster
    kube-proxy = true # Handles network communication between nodes and the cluster
    vpc-cni    = true # Manages pod networking within the VPC
  }

  # Cluster network configuration
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets # Uses private subnets for EKS worker nodes

  # Default settings for managed nodes
  eks_managed_node_group_defaults = {
    ami_type = var.ami
  }

  # Managed Node Groups
  eks_managed_node_groups = {
    default = {
      name           = "node-group-1"
      instance_types = var.worker_instance_type
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}

# =========================================
# IAM Policy for EBS CSI Driver
# =========================================

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# =========================================
# IAM Role with OIDC for EBS CSI Driver
# =========================================

module "irsa_ebs_csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role      = true
  role_name        = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url     = module.eks.oidc_provider
  role_policy_arns = [data.aws_iam_policy.ebs_csi_policy.arn]

  # Defines service accounts that can assume the role via OIDC
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:kube-system:ebs-csi-controller-sa"
  ]
}
