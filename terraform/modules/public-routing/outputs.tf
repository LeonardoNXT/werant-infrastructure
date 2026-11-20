output "internet_gateway_arn" {
  description = "ARN of the Internet Gateway"
  value       = aws_internet_gateway.gateway.arn
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.gateway.id
}

output "route_table_arn" {
  description = "ARN of the public route table"
  value       = aws_route_table.public.arn
}

output "route_table_association_id" {
  description = "ID of the public subnet route table association"
  value       = aws_route_table_association.public_subnet.id
}

output "route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}
