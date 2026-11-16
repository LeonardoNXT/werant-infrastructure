output "aws_iam_role_arn" {
  description = "IAM service role ARN"
  value       = aws_iam_role.service_role.arn
}

output "aws_iam_role_id" {
  description = "IAM service role ID"
  value       = aws_iam_role.service_role.id
}

output "aws_iam_role_name" {
  description = "IAM service role name"
  value       = aws_iam_role.service_role.name
}
