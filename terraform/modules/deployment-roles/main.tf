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
  name               = "${var.life_cycle_name}-terraform-deploy-role"
  description        = var.role_description
  tags               = var.tags
  assume_role_policy = data.aws_iam_policy_document.werant_deployment_trusted_policy.json
}
