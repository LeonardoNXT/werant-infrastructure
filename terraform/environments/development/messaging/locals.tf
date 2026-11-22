locals {
  development_account_id = "904054820030"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Messaging"
    ManagedBy   = "Terraform"
  }

  key_rotation_scheduler = {
    execution_role_name  = "werant-auth-key-rotation-scheduler-role-dev"
    group_name           = "werant-auth-key-rotation-dev"
    lambda_alias_name    = "live"
    lambda_function_name = "werant-auth-key-rotation-dev"
    timezone             = "America/Sao_Paulo"
  }
}
