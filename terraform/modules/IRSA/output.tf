output "alb_controller_role_arn" {
  value = aws_iam_role.this.arn
  description = "ARN of ALB Controller IAM Role for IRSA"
}
