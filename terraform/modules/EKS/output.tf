output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

data "aws_eks_node_group" "managed" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = aws_eks_node_group.managed.node_group_name
}

output "node_group_sg_id" {
  value = data.aws_eks_node_group.managed.resources[0].security_groups[0]
}