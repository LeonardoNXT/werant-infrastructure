locals {
  development_account_id = "904054820030"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Messaging"
    ManagedBy   = "Terraform"
  }

  key_rotation_scheduler = {
    group_name = "werant-auth-key-rotation-dev"
  }
}
