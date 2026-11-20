locals {
  development_account_id = "904054820030"

  role_arns = {
    application_runtime      = "arn:aws:iam::${local.development_account_id}:role/werant-application-ec2-role-dev"
    auth_key_rotation_lambda = "arn:aws:iam::${local.development_account_id}:role/auth-key-rotation-lambda-role-dev"
    security_deployment      = "arn:aws:iam::${local.development_account_id}:role/security-terraform-deploy-role"
  }

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Security"
    ManagedBy   = "Terraform"
  }
}
