output "aws_iam_policy_document_arn" {
  value = aws_iam_policy.deployment_iam_policy.arn
}

output "aws_iam_policy_document_id" {
  value = aws_iam_policy.deployment_iam_policy.id
}
