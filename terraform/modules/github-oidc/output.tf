
output "aws_identity_provider_arn" {
  value = aws_iam_openid_connect_provider.werant_github_oidc.arn
}


output "aws_identity_provider_id" {
  value = aws_iam_openid_connect_provider.werant_github_oidc.id
}
