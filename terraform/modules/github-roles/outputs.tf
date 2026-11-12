output "aws_iam_role_arn" {
  description = "Github Terraform-apply instace ARN"
  value       = aws_iam_role.this.arn
}

output "aws_iam_role_arn" {
  description = "Github Terraform-apply instace ID"
  value       = aws_iam_role.this.id
}

output "aws_iam_role_name" {
  description = "Github Terraform-apply instace NAME"
  value       = aws_iam_role.this.name
}
