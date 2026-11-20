resource "aws_vpc" "virtual_connection" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !var.enable_dns_hostnames || var.enable_dns_support
      error_message = "enable_dns_support must be true when enable_dns_hostnames is enabled."
    }
  }
}


