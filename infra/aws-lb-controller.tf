resource "aws_iam_role" "lb_controller" {
  name = "eks-lb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.eks.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM Policy for AWS Load Balancer Controller"
  policy      = file("iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "lb_controller_attach" {
  role       = aws_iam_role.lb_controller.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}


resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lb_controller.arn # Anexa a Role correta à SA
  }

  # Adiciona os valores do map como argumentos "set"
  dynamic "set" {
    for_each = merge(var.aws_load_balancer_controller_config, {
      vpcId       = module.vpc.vpc_id,
      clusterName = module.eks.cluster_name
    })
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    module.eks.eks_cluster_name,
    aws_iam_role.lb_controller,
    aws_iam_role_policy_attachment.lb_controller_attach
  ]
}
