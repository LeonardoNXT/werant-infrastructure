resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  referenced_security_group_id = each.value.referenced_security_group_id
  description                  = each.value.description
  from_port                    = each.value.ip_protocol == "-1" ? null : each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.ip_protocol == "-1" ? null : each.value.to_port

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  referenced_security_group_id = each.value.referenced_security_group_id
  description                  = each.value.description
  from_port                    = each.value.ip_protocol == "-1" ? null : each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.ip_protocol == "-1" ? null : each.value.to_port

  tags = var.tags
}
