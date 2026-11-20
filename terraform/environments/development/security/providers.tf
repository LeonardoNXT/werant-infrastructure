provider "aws" {
  region              = "sa-east-1"
  allowed_account_ids = [local.development_account_id]

  default_tags {
    tags = local.common_tags
  }
}
