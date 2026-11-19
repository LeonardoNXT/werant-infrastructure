locals {
  administration_actions = [
    "kms:CancelKeyDeletion",
    "kms:CreateAlias",
    "kms:DescribeKey",
    "kms:EnableKey",
    "kms:EnableKeyRotation",
    "kms:GetKeyPolicy",
    "kms:GetKeyRotationStatus",
    "kms:ListResourceTags",
    "kms:PutKeyPolicy",
    "kms:ScheduleKeyDeletion",
    "kms:TagResource",
    "kms:UpdateAlias",
    "kms:UpdateKeyDescription"
  ]
}

data "aws_iam_policy_document" "key" {
  statement {
    sid    = "AllowExplicitKeyAdministration"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = concat(
        ["arn:aws:iam::${var.account_id}:root"],
        sort(tolist(var.administrator_role_arns))
      )
    }

    actions   = local.administration_actions
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.data_key_generator_role_arns) > 0 ? [1] : []

    content {
      sid    = "AllowDataKeyGeneration"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = sort(tolist(var.data_key_generator_role_arns))
      }

      actions = [
        "kms:DescribeKey",
        "kms:GenerateDataKey"
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = length(var.decryptor_role_arns) > 0 ? [1] : []

    content {
      sid    = "AllowDataKeyDecryption"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = sort(tolist(var.decryptor_role_arns))
      }

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey"
      ]
      resources = ["*"]
    }
  }
}

resource "aws_kms_key" "key" {
  description                        = var.description
  key_usage                          = "ENCRYPT_DECRYPT"
  customer_master_key_spec           = "SYMMETRIC_DEFAULT"
  is_enabled                         = true
  multi_region                       = false
  enable_key_rotation                = true
  rotation_period_in_days            = 90
  deletion_window_in_days            = 30
  bypass_policy_lockout_safety_check = false
  policy                             = data.aws_iam_policy_document.key.json
  tags                               = var.tags
}

resource "aws_kms_alias" "key" {
  name          = var.alias_name
  target_key_id = aws_kms_key.key.key_id
}
