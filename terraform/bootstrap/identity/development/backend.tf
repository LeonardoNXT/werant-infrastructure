terraform {
  backend "s3" {
    bucket              = "werant-tfstate-633697459676"
    key                 = "bootstrap/identity/development/terraform.tfstate"
    region              = "sa-east-1"
    allowed_account_ids = ["904054820030"]
    encrypt             = true
    use_lockfile        = true
  }
}
