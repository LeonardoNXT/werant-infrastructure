output "vpc" {
  description = "Identifiers and CIDR for the Development VPC"
  value = {
    arn             = module.vpc.aws_vpc_arn
    cidr_block      = local.cidr_blocks.vpc
    id              = module.vpc.aws_vpc_id
    ipv6_cidr_block = module.vpc.aws_vpc_ipv6_cidr_block
  }
}

output "public_subnet" {
  description = "Identifiers and placement for the initial public subnet"
  value = {
    arn               = module.public_subnet.aws_subnet_arn
    availability_zone = local.primary_availability_zone
    cidr_block        = local.cidr_blocks.public_subnet
    id                = module.public_subnet.aws_subnet_id
  }
}

output "public_routing" {
  description = "Identifiers for the public Internet Gateway and route table"
  value = {
    internet_gateway_arn       = module.public_routing.internet_gateway_arn
    internet_gateway_id        = module.public_routing.internet_gateway_id
    route_table_arn            = module.public_routing.route_table_arn
    route_table_association_id = module.public_routing.route_table_association_id
    route_table_id             = module.public_routing.route_table_id
  }
}

output "application_security_group_id" {
  description = "ID of the Security Group attached to the Development application node"
  value       = module.application_security_group.id
}

output "application_security_group_arn" {
  description = "ARN of the Security Group attached to the Development application node"
  value       = module.application_security_group.arn
}
