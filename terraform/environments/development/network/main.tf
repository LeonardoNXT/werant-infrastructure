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

module "public_routing" {
  source = "../../../modules/public-routing"

  vpc_id                = module.vpc.aws_vpc_id
  subnet_id             = module.public_subnet.aws_subnet_id
  internet_gateway_name = "werant-dev-internet-gateway"
  route_table_name      = "werant-dev-public-routes"

  tags = merge(local.common_tags, {
    Tier     = "Public"
    Workload = "PublicRouting"
  })
}
