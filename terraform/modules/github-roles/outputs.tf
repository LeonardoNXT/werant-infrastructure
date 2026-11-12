output "aws_iam_role_arn" {
  description = "Github Terraform-apply instace ARN"
  value       = aws_iam_role.werant_github_oidc_role.arn
}

output "aws_iam_role_arn" {
  description = "Github Terraform-apply instace ID"
  value       = aws_iam_role.werant_github_oidc_role.id
}

output "aws_iam_role_name" {
  description = "Github Terraform-apply instace NAME"
  value       = aws_iam_role.werant_github_oidc_role.name
}
