locals {
  development_account_id = "904054820030"
  storage_kms_alias_name = "alias/werant-storage-dev"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Storage"
    ManagedBy   = "Terraform"
  }
}
