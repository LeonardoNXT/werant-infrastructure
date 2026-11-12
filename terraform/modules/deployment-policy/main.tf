data "aws_iam_policy_document" "deployment_iam_policy_document" {
  dynamic "statement" {
    for_each = var.role_statements

    content {
      sid       = statement.value.sid
      effect    = statament.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "deployment_iam_policy" {
  name        = var.role_name
  description = var.role_description
  policy      = data.aws_iam_policy_document.deployment_iam_policy_document.json
  tags        = var.tags
}

