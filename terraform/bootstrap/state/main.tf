
resource "aws_s3_bucket" "terraform_state" {
  bucket = "werant-tfstate-633697459676"

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "terraform_state_kms" {
  statement {
    sid    = "EnableManagementAccountAdministration"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.trusted_state_accounts) > 0 ? [1] : []

    content {
      sid    = "AllowTrustedAccountsToUseStateKey"
      effect = "Allow"

      principals {
        type = "AWS"
        identifiers = [
          for account in var.trusted_state_accounts :
          "arn:aws:iam::${account.account_id}:root"
        ]
      }

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ]
      resources = ["*"]
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "terraform_state" {
  description             = "Encrypts the centralized Werant Terraform state"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.terraform_state_kms.json

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "terraform_state" {
  name          = "alias/werant-terraform-state"
  target_key_id = aws_kms_key.terraform_state.key_id
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "terraform_state_bucket" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DenyUnexpectedEncryptionAlgorithm"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DenyUploadsWithUnexpectedKmsKey"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values = [
        aws_kms_key.terraform_state.arn,
        aws_kms_alias.terraform_state.arn
      ]
    }

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["false"]
    }
  }

  dynamic "statement" {
    for_each = var.trusted_state_accounts
    iterator = trusted_account

    content {
      sid    = "Allow${title(trusted_account.key)}AccountToListStatePrefixes"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${trusted_account.value.account_id}:root"]
      }

      actions   = ["s3:ListBucket"]
      resources = [aws_s3_bucket.terraform_state.arn]

      condition {
        test     = "StringLike"
        variable = "s3:prefix"
        values   = trusted_account.value.prefixes
      }
    }
  }

  dynamic "statement" {
    for_each = var.trusted_state_accounts
    iterator = trusted_account

    content {
      sid    = "Allow${title(trusted_account.key)}AccountToAccessStatePrefixes"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${trusted_account.value.account_id}:root"]
      }

      actions = [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ]
      resources = [
        for prefix in trusted_account.value.prefixes :
        "${aws_s3_bucket.terraform_state.arn}/${prefix}"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state_bucket.json

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.terraform_state]
}
