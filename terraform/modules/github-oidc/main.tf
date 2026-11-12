resource "aws_iam_openid_connect_provider" "werant_github_oidc" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  tags = {
    Name = "WerantGitHubOIDC"
  }
}
