output "aws_iam_policy_arn" {
  value = aws_iam_policy.werant-terraform-state-access-policy.arn
}

output "aws_iam_policy_id" {
  value = aws_iam_policy.werant-terraform-state-access-policy.id
}
