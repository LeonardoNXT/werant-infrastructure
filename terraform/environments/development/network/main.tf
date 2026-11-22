module "vpc" {
  source = "../../../modules/vpc-instance"

  cidr_block                       = local.cidr_blocks.vpc
  assign_generated_ipv6_cidr_block = true

  tags = merge(local.common_tags, {
    Name     = "werant-dev-vpc"
    Tier     = "Foundation"
    Workload = "CoreNetwork"
  })
}

module "public_subnet" {
  source = "../../../modules/subnet-instance"

  vpc_id                                         = module.vpc.aws_vpc_id
  availability_zone                              = local.primary_availability_zone
  cidr_block                                     = local.cidr_blocks.public_subnet
  ipv6_cidr_block                                = cidrsubnet(module.vpc.aws_vpc_ipv6_cidr_block, 8, 0)
  map_public_ip_on_launch                        = true
  assign_ipv6_address_on_creation                = true
  enable_resource_name_dns_aaaa_record_on_launch = true

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
  enable_ipv6_egress    = true

  tags = merge(local.common_tags, {
    Tier     = "Public"
    Workload = "PublicRouting"
  })
}

module "application_security_group" {
  source = "../../../modules/security-group"

  name        = "werant-dev-application"
  description = "Public ingress for the Werant Development application node"
  vpc_id      = module.vpc.aws_vpc_id

  ingress_rules = {
    http = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Public HTTP ingress redirected to HTTPS by Traefik"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    }

    https = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Public HTTPS ingress terminated by Traefik"
      from_port   = 443
      ip_protocol = "tcp"
      to_port     = 443
    }
  }

  egress_rules = {
    all_ipv4 = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Outbound access for bootstrap, registries, updates, and application dependencies"
      from_port   = 0
      ip_protocol = "-1"
      to_port     = 0
    }
  }

  tags = merge(local.common_tags, {
    Tier     = "Public"
    Workload = "ApplicationIngress"
  })
}
