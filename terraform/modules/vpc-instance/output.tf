output "aws_vpc_arn" {
  description = "VPC ARN"
  value       = aws_vpc.virtual_connection.arn
}

output "aws_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.virtual_connection.id
}
