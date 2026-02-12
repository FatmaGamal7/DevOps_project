#  Cluster Role
resource "aws_iam_role" "cluster" {
  name = "${var.env}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.env}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "cluster_eks_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_vpc_controller" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

#  Node Group Role
resource "aws_iam_role" "node" {
  name = "${var.env}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.env}-eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_worker" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_ecr" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Fargate Role
resource "aws_iam_role" "fargate" {
  name = "${var.env}-eks-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "eks-fargate-pods.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.env}-eks-fargate-role"
  }
}

resource "aws_iam_role_policy_attachment" "fargate_execution" {
  role       = aws_iam_role.fargate.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}


#############

# # 1. اقرأي بيانات الكلاستر اللي اتكريت فعلاً
# data "aws_eks_cluster" "current" {
#   name = var.eks_cluster_name
# }

# # الحصول على شهادة الأمان للرابط الخاص بـ EKS
# data "tls_certificate" "eks" {
#   url = data.aws_eks_cluster.current.identity[0].oidc[0].issuer
# }

# # إنشاء الـ OIDC Provider
# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url             = data.aws_eks_cluster.current.identity[0].oidc[0].issuer
# }

# data "aws_iam_policy_document" "ebs_csi_irsa_assume" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(data.aws_eks_cluster.current.identity[0].oidc[0].issuer, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "${replace(data.aws_eks_cluster.current.identity[0].oidc[0].issuer, "https://", "")}:aud"
#       values   = ["sts.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "ebs_csi_driver" {
#   name               = "ebs-csi-role"
#   assume_role_policy = data.aws_iam_policy_document.ebs_csi_irsa_assume.json
# }

# resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_irsa" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#   role       = aws_iam_role.ebs_csi_driver.name
# }

# resource "aws_eks_addon" "ebs_csi_driver" {
#   cluster_name                = var.eks_cluster_name
#   addon_name                  = "aws-ebs-csi-driver"
#   addon_version               = "v1.31.0-eksbuild.1" # Using a known stable version for 1.30
#   resolve_conflicts_on_create = "OVERWRITE"
#   resolve_conflicts_on_update = "OVERWRITE"
#   service_account_role_arn    = aws_iam_role.ebs_csi_driver.arn

# }