data "aws_iam_policy_document" "service_trust" {
  statement {
    sid     = var.sid
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.service_principals
    }
  }
}

resource "aws_iam_role" "service_role" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.service_trust.json
  tags               = var.tags
}
