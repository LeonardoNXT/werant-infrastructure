resource "aws_iam_role" "werant_github_oidc_role" {
  name        = var.role_name
  description = var.role_description

  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGithubOIDC"
        Effect = "Allow"
        Principal = {
          Federated = var.federated_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = merge(
            var.custom_conditions,
            {
              "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            },
          )
        }
      }
    ]
  })
}
