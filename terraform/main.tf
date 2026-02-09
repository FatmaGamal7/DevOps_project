# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr_prod
}

# public Subnets
module "public_subnets" {
  source = "./modules/public_subnet"
  count  = length(local.public_cidrs)

  vpc_id            = module.vpc.vpc_id
  cidr_block        = local.public_cidrs[count.index]
  availability_zone = local.availability_zones[count.index]
}


# Private Subnets (2 AZs)
module "private_subnets" {
  source = "./modules/private_subnet"
  count  = length(local.private_cidrs)

  vpc_id            = module.vpc.vpc_id
  cidr_block        = local.private_cidrs[count.index]
  availability_zone = local.availability_zones[count.index]
}

# Internet Gateway
module "igw" {
  source = "./modules/IGW"
  vpc_id = module.vpc.vpc_id
}

# NAT Gateway
module "nat" {
  source           = "./modules/NAT"
  public_subnet_id = module.public_subnets[0].public_subnet_id
  igw_id           = module.igw.IGW_id
  env              = var.env
}

# Public Route Tables
module "public_rts" {
  source    = "./modules/public_routetable"
  count  = length(module.public_subnets)

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.public_subnets[count.index].public_subnet_id
  igw_id    = module.igw.IGW_id
}


# Private Route Tables (Shared NAT)
module "private_rts" {
  source    = "./modules/private_routetable"
  count  = length(module.private_subnets)
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.private_subnets[count.index].private_subnet_id
  nat_id    = module.nat.nat_id
}

###############################
# IAM and EKS
module "IAM" {
  source           = "./modules/IAM"
  env              = var.env
  eks_cluster_name = "my-eks-cluster"
}

module "EKS" {
  source       = "./modules/EKS"
  cluster_name = "my-eks-cluster"
  env          = var.env

  # Collect all public and private subnet IDs into one list for EKS cluster
  subnet_ids = concat(
    [for s in module.public_subnets : s.public_subnet_id],
    [for s in module.private_subnets : s.private_subnet_id]
  )

  # Private subnets only for node groups / fargate
  private_subnet_ids = [for s in module.private_subnets : s.private_subnet_id]

  iam_module = module.IAM
}
#############################################

#_________________________________________

# ECR
module "ecr" {
  source = "./modules/ECR"
  

  env = var.env
}

# Cognito
module "cognito" {
  source = "./modules/cognito"

  env    = var.env
  region = var.region
}

# API Gateway + VPC Link
# module "api_gateway" {
#   source = "./modules/APIGW"

#   env                 = var.env
#   region              = var.region

#   vpc_id              = module.vpc.vpc_id
#   private_subnets     = module.private_subnets[*].private_subnet_id

#   user_pool_id        = module.cognito.user_pool_id
#   user_pool_client_id = module.cognito.user_pool_client_id
# }

module "api_gateway" {
  source = "./modules/APIGW"

  env                 = var.env
  region              = var.region
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.private_subnets[*].private_subnet_id

  user_pool_id        = module.cognito.user_pool_id
  user_pool_client_id = module.cognito.user_pool_client_id

  nlb_arn             = module.nlb.nlb_arn
  nlb_listener_arn    = module.nlb.listener_arn
  nlb_listener_id     = module.nlb.listener_id
  vpc_link_id         = module.api_gateway.vpc_link_id
}




# Network Load Balancer
module "nlb" {
  source      = "./modules/NLB"
  name        = "my-nlb"
  env         = var.env
  subnet_ids  = module.public_subnets[*].public_subnet_id
  scheme      = "internet-facing"
  listener_port = 80
  vpc_id      = module.vpc.vpc_id
}



###########sg to nlb correction

resource "aws_security_group_rule" "nlb_to_nodes" {
  type              = "ingress"
  from_port         = 30081               # NodePort الجديد
  to_port           = 30081
  protocol          = "tcp"
  security_group_id = module.EKS.node_group_sg_id
  cidr_blocks       = ["0.0.0.0/0"]       # لو NLB public
}
