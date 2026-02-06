variable "region" {
  type = string
}

variable "env" {
  description = "Environment name: prod or nonprod"
  type        = string
  default = "prod"
}

variable "vpc_cidr_prod" {
  type = string
}

variable "vpc_cidr_nonprod" {
  type = string
}

variable "public_cidr_prod" {
  type = string
}

variable "private_cidr_prod" {
  type = string
}

variable "public_cidr_nonprod" {
  type = string
}

variable "private_cidr_nonprod" {
  type = string
}

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "user_pool_name" {
  type        = string
  default = "my_pool"
}

variable "vpc_link_sg" {
  type        = string
}

variable "nlb_name" {
  type        = string
  default     = "my-nlb"
}

variable "nlb_internal" {
  description = "Is the NLB internal?"
  type        = bool
  default     = true
}

variable "nlb_subnet_ids" {
  description = "Private subnet IDs for NLB targets"
  type        = list(string)
}

variable "cognito_client_id" {
  description = "Cognito App Client ID (for JWT)"
  type        = string
}

variable "cognito_issuer_url" {
  description = "Cognito JWT issuer URL"
  type        = string
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

