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
        var.target_state_key,
        "${var.target_state_key}.tflock"
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

  statement {
    sid    = "UseStateEncryptionKey"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      var.kms_key_arn
    ]
  }
}

resource "aws_iam_policy" "werant-terraform-state-access-policy" {
  name        = var.policy_name
  description = "Grants access to one Terraform state object, its lock file, and its encryption key."

  policy = data.aws_iam_policy_document.werant-terraform-state-access-policy-document.json
  tags   = var.tags
}
