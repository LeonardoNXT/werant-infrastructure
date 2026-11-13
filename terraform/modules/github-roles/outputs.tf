output "aws_iam_role_arn" {
  description = "GitHub OIDC IAM role ARN"
  value       = aws_iam_role.werant_github_oidc_role.arn
}

output "aws_iam_role_id" {
  description = "GitHub OIDC IAM role ID"
  value       = aws_iam_role.werant_github_oidc_role.id
}

output "aws_iam_role_name" {
  description = "GitHub OIDC IAM role name"
  value       = aws_iam_role.werant_github_oidc_role.name
}
