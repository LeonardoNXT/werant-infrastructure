resource "aws_internet_gateway" "gateway" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = var.internet_gateway_name
  })
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = var.route_table_name
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_egress_only_internet_gateway" "ipv6" {
  count = var.enable_ipv6_egress ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.route_table_name}-ipv6-egress"
  })
}

resource "aws_route" "ipv6_egress" {
  count = var.enable_ipv6_egress ? 1 : 0

  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.ipv6[0].id
}

resource "aws_route_table_association" "public_subnet" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.subnet_id
}
