data "aws_iam_policy_document" "deployment_iam_policy_document" {
  dynamic "statement" {
    for_each = var.role_statements

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "deployment_iam_policy" {
  name        = var.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.deployment_iam_policy_document.json
  tags        = var.tags
}

