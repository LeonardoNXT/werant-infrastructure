output "aws_iam_policy_arn" {
  description = "Terraform state access policy ARN"
  value       = aws_iam_policy.werant-terraform-state-access-policy.arn
}

output "aws_iam_policy_id" {
  description = "Terraform state access policy ID"
  value       = aws_iam_policy.werant-terraform-state-access-policy.id
}
