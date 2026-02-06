variable "name" {
  description = "Name of the NLB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the NLB will be deployed"
  type        = list(string)
}

variable "env" {
  description = "Environment (prod/nonprod)"
  type        = string
}

variable "scheme" {
  description = "internet-facing or internal"
  type        = string
  default     = "internet-facing"
}
variable "vpc_id" {
  type = string
}