output "vpc" {
  description = "Identifiers and CIDR for the Development VPC"
  value = {
    arn        = module.vpc.aws_vpc_arn
    cidr_block = local.cidr_blocks.vpc
    id         = module.vpc.aws_vpc_id
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
