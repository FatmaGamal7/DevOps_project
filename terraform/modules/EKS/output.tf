output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}
output "node_group_sg_id" {
  value       = aws_eks_node_group.managed.resources_security_group_id
  description = "Security Group of EKS worker nodes"
}