data "aws_iam_policy_document" "werant_deployment_trusted_policy" {
  statement {
    sid     = var.sid
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.root_account_id}:role/${var.github_oidc_role_name}"
      ]
    }

  }
}

resource "aws_iam_role" "werant_deployment_role" {
  name               = "${var.resource_name}-terraform-deploy-role"
  description        = "IAM role assumed by GitHub Actions via cross-account federation to provision and manage ${var.resource_name} infrastructure using Terraform."
  tags               = var.tags
  assume_role_policy = data.aws_iam_policy_document.werant_deployment_trusted_policy.json
}
