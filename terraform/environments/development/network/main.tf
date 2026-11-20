module "vpc" {
  source = "../../../modules/vpc-instance"

  cidr_block = local.cidr_blocks.vpc

  tags = merge(local.common_tags, {
    Name     = "werant-dev-vpc"
    Tier     = "Foundation"
    Workload = "CoreNetwork"
  })
}

module "public_subnet" {
  source = "../../../modules/subnet-instance"

  vpc_id                  = module.vpc.aws_vpc_id
  availability_zone       = local.primary_availability_zone
  cidr_block              = local.cidr_blocks.public_subnet
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name     = "werant-dev-public-1"
    Tier     = "Public"
    Workload = "ApplicationIngress"
  })
}
