locals {
  target_state_arn = "${var.bucket_arn}/${var.target_state_key}"
}

data "aws_iam_policy_document" "werant-terraform-state-access-policy-document" {
  statement {
    sid    = "AllowListStateBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.bucket_arn
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:prefix"

      values = [
        var.target_state_key
      ]
    }
  }

  statement {
    sid    = "ReadAndWriteState"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      local.target_state_arn
    ]
  }

  statement {
    sid    = "ManageStateLock"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject"
    ]

    resources = [
      "${local.target_state_arn}.tflock"
    ]
  }
}

resource "aws_iam_policy" "werant-terraform-state-access-policy" {
  name        = "TerraformApply"
  description = "Grants the required permissions to provision, update, and manage AWS infrastructure resources through Terraform."

  policy = data.aws_iam_policy_document.werant-terraform-apply-policy-document.json
  tags   = var.tags
}
