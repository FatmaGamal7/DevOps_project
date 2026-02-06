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