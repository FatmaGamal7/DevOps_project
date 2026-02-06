region = "us-east-1"
env    = "nonprod"

vpc_cidr_nonprod = "10.1.0.0/16"

public_cidr_nonprod  = "10.0.11.0/24"
private_cidr_nonprod = "10.0.12.0/24"

availability_zone_1 = "us-east-1a"
availability_zone_2 = "us-east-1b"

# Cognito outputs
cognito_client_id  = "nonprod-client-id"
cognito_issuer_url = "https://nonprod-auth-domain.auth.us-east-1.amazoncognito.com"

# NLB
nlb_subnet_ids = ["subnet-xyz123", "subnet-xyz456"]

# API Gateway
vpc_link_sg = "sg-0fedcba9876543210"

# Datadog
datadog_api_key = "xxxxxx-your-key-xxxxxx"