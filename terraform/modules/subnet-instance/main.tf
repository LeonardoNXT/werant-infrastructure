resource "aws_subnet" "instance" {
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  cidr_block        = var.cidr_block
  ipv6_cidr_block   = var.ipv6_cidr_block

  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation

  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !var.assign_ipv6_address_on_creation || var.ipv6_cidr_block != null
      error_message = "ipv6_cidr_block must be set when assign_ipv6_address_on_creation is enabled."
    }
  }
}
