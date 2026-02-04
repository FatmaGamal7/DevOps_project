variable "region" {
  type = string
}

variable "env" {
  description = "Environment name: prod or nonprod"
  type        = string
  default = "nonprod"
}

variable "vpc_cidr" {
  type = string
}

# variable "vpc_cidr_nonprod" {
#   type = string
# }

variable "public_cidr" {
  type = string
}

variable "private_cidr" {
  type = string
}

variable "data_cidr" {
  type = string
}

# variable "data_cidr_nonprod" {
#   type = string
# }

# variable "public_cidr_nonprod" {
#   type = string
# }

# variable "private_cidr_nonprod" {
#   type = string
# }

variable "availability_zone" {
  type = string
}

# variable "availability_zone_2" {
#   type = string
# }
