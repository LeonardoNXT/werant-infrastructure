provider "aws" {
  region = "sa-east-1"

  default_tags {
    tags = {
      Project   = "Identity Development Werant"
      ManagedBy = "Terraform"
    }
  }
}
