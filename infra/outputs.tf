output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
