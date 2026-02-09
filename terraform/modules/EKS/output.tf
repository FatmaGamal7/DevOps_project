output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "oidc_issuer_url" {
  value = module.EKS.eks_cluster_oidc_issuer
}


