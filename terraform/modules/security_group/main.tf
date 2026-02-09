resource "aws_security_group" "apigw_vpc_link_sg" {
  name   = "${var.env}-apigw-sg-${random_id.suffix.hex}"
  vpc_id = var.vpc_id
  description = "Security group for API Gateway VPC Link"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}


#sg to eks node group
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.env}-eks-nodes"
  description = "SG for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
