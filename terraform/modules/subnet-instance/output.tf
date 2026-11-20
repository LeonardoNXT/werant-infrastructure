output "aws_subnet_arn" {
  description = "ARN of the managed subnet"
  value       = aws_subnet.instance.arn
}

output "aws_subnet_id" {
  description = "ID of the managed subnet"
  value       = aws_subnet.instance.id
}
