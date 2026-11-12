resource "aws_vpc" "virtual_connection" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.tags
}


