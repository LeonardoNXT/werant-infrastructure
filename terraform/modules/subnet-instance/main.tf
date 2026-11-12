resource "aws_subnet" "instance" {
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  cidr_block        = var.cidr_block

  map_public_ip_on_launch = var.map_public_ip_on_launch

  private_dns_hostname_type_on_launch         = "resource-name"
  enable_resource_name_dns_a_record_on_launch = true


  tags = var.tags
}
