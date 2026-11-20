output "aws_vpc_arn" {
  description = "ARN of the managed VPC"
  value       = aws_vpc.virtual_connection.arn
}

output "aws_vpc_id" {
  description = "ID of the managed VPC"
  value       = aws_vpc.virtual_connection.id
}
