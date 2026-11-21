data "terraform_remote_state" "identity" {
  backend = "s3"

  config = {
    bucket              = local.state_bucket_name
    key                 = "bootstrap/identity/development/terraform.tfstate"
    region              = "sa-east-1"
    allowed_account_ids = [local.development_account_id]
    encrypt             = true
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket              = local.state_bucket_name
    key                 = "development/network/terraform.tfstate"
    region              = "sa-east-1"
    allowed_account_ids = [local.development_account_id]
    encrypt             = true
  }
}
