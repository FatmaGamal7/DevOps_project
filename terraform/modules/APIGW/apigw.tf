###########################
# Security Group for VPC Link
###########################
resource "aws_security_group" "vpc_link_sg" {
  name        = "${var.env}-vpc-link-sg"
  vpc_id      = var.vpc_id
  description = "Security group for API Gateway VPC Link"

  ingress {
    from_port   = 80
    to_port     = 80
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

###########################
# HTTP API
###########################
resource "aws_apigatewayv2_api" "this" {
  name          = "${var.env}-http-api"
  protocol_type = "HTTP"
}

###########################
# Cognito JWT Authorizer
###########################
resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "${var.env}-cognito-authorizer"

  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [var.user_pool_client_id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.user_pool_id}"
  }
}

###########################
# VPC Link
###########################
resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.env}-vpc-link"
  subnet_ids         = var.private_subnets
  security_group_ids = [aws_security_group.vpc_link_sg.id]
}

###########################
# Integration with NLB
###########################
resource "aws_apigatewayv2_integration" "nlb" {
  api_id            = aws_apigatewayv2_api.this.id
  integration_type  = "HTTP_PROXY"
  integration_uri   = var.nlb_listener_arn
  connection_type   = "VPC_LINK"
  connection_id     = aws_apigatewayv2_vpc_link.this.id
  integration_method = "ANY"
  timeout_milliseconds = 30000
}

###########################
# Default Stage
###########################
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

###########################
# Default Route ($default)
###########################
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.nlb.id}"
}




# resource "aws_security_group" "vpc_link_sg" {
#   name        = "${var.env}-vpc-link-sg"
#   vpc_id      = var.vpc_id
#   description = "Security group for API Gateway VPC Link"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] 
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_apigatewayv2_api" "this" {
#   name          = "${var.env}-http-api"
#   protocol_type = "HTTP"
# }

# resource "aws_apigatewayv2_authorizer" "cognito" {
#   api_id = aws_apigatewayv2_api.this.id
#   name   = "${var.env}-cognito-authorizer"

#   authorizer_type  = "JWT"
#   identity_sources = ["$request.header.Authorization"]

#   jwt_configuration {
#     audience = [var.user_pool_client_id]
#     issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.user_pool_id}"
#   }
# }

# resource "aws_apigatewayv2_vpc_link" "this" {
#   name               = "${var.env}-vpc-link"
#   subnet_ids         = var.private_subnets
#   security_group_ids = [aws_security_group.vpc_link_sg.id]
# }

# resource "aws_apigatewayv2_stage" "default" {
#   api_id      = aws_apigatewayv2_api.this.id
#   name        = "$default"
#   auto_deploy = true
# }

# resource "aws_apigatewayv2_integration" "nlb" {
#   api_id            = aws_apigatewayv2_api.this.id
#   integration_type  = "HTTP_PROXY"      
#   integration_uri   = var.nlb_listener_arn 
#   connection_type   = "VPC_LINK"
#   connection_id     = var.vpc_link_id
#   integration_method = "ANY"
# }



