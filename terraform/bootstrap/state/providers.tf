provider "aws" {
  region = "sa-east-1"

  default_tags {
    tags = {
      Project   = "DEV Werant"
      ManagedBy = "Terraform"
    }
  }
}
