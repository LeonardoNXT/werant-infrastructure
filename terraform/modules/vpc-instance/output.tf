output "aws_vpc_arn" {
  type  = "VPN instance ARN"
  value = aws_vpc.virtual_connection.arn
}

output "aws_vpc_arn" {
  type  = "VPN instance ID"
  value = aws_vpc.virtual_connection.id
}
