data "aws_iam_policy_document" "oidc_policy_document" {
  statement {
    sid    = var.oidc_policy_document_sid
    effect = "Allow"
    resources = [
      "arn:aws:iam::${var.target_account_id}:role/${var.oidc_policy_document_role_name}"
    ]
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "oidc-policy" {
  name        = var.oidc_policy_name
  description = var.oidc_policy_description
  path        = "/"
  policy      = data.aws_iam_policy_document.oidc_policy_document.json
}
