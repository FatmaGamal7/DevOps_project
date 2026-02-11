output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

#############
output "cluster_oidc_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}