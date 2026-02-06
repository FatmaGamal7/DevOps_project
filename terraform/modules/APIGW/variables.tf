variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "user_pool_id" {
  type = string
}

variable "user_pool_client_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "nlb_arn" {
  type        = string
  description = "ARN of the Network Load Balancer"
}

variable "nlb_listener_id" {
  type        = string
  description = "Listener ID of the Network Load Balancer"
}

variable "vpc_link_id" {
  type        = string
  description = "ID of the VPC Link to connect API Gateway to NLB"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID (can use data.aws_caller_identity.current.account_id)"
  default     = ""  # optional if we use data.aws_caller_identity
}

variable "nlb_listener_arn" {
  type        = string
  description = "ARN of the NLB listener to integrate with API Gateway"
}

########
data "aws_caller_identity" "current" {}





