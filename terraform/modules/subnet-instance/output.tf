output "aws_subnet_arn" {
  description = "ARN of the managed subnet"
  value       = aws_subnet.instance.arn
}

output "aws_subnet_id" {
  description = "ID of the managed subnet"
  value       = aws_subnet.instance.id
}

output "aws_subnet_ipv6_cidr_block" {
  description = "IPv6 CIDR block assigned to the subnet"
  value       = aws_subnet.instance.ipv6_cidr_block
}
