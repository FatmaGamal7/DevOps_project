terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


# provider "helm" {
#   kubernetes {
#     host                   = module.EKS.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.EKS.cluster_certificate_authority)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }

