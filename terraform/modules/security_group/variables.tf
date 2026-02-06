variable "env" {
  description = "Environment name: prod or nonprod"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the SG will be created"
  type        = string
}

variable "private_cidrs" {
  description = "List of private CIDRs allowed to access API Gateway"
  type        = list(string)
}
