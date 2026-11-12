terraform {
  backend "s3" {
    bucket              = "werant-tfstate-633697459676"
    key                 = "bootstrap/terraform.tfstate"
    region              = "sa-east-1"
    allowed_account_ids = ["633697459676"]
    encrypt             = true
    use_lockfile        = true
  }
}
