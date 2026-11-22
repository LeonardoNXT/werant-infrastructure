output "aws_vpc_arn" {
  description = "ARN of the managed VPC"
  value       = aws_vpc.virtual_connection.arn
}

output "aws_vpc_id" {
  description = "ID of the managed VPC"
  value       = aws_vpc.virtual_connection.id
}

output "aws_vpc_ipv6_cidr_block" {
  description = "Amazon-provided IPv6 CIDR block assigned to the VPC"
  value       = aws_vpc.virtual_connection.ipv6_cidr_block
}
