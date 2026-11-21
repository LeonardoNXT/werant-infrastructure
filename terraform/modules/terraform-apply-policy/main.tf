locals {
  target_state_arn = "${var.bucket_arn}/${var.target_state_key}"
  read_only_state_arns = [
    for key in sort(tolist(var.read_only_state_keys)) :
    "${var.bucket_arn}/${key}"
  ]
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

      values = concat(
        [
          var.target_state_key,
          "${var.target_state_key}.tflock"
        ],
        sort(tolist(var.read_only_state_keys))
      )
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

  dynamic "statement" {
    for_each = length(var.read_only_state_keys) > 0 ? [1] : []

    content {
      sid    = "ReadDependentStates"
      effect = "Allow"

      actions = [
        "s3:GetObject"
      ]

      resources = local.read_only_state_arns
    }
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
  description = "Grants read-write access to one Terraform state, its lock, and read-only access to declared state dependencies."

  policy = data.aws_iam_policy_document.werant-terraform-state-access-policy-document.json
  tags   = var.tags
}
