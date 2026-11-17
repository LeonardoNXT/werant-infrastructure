data "aws_iam_policy_document" "auth_key_rotation_lambda_runtime" {
  statement {
    sid    = "WriteFunctionLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:sa-east-1:${local.aws_accounts.development}:log-group:${local.runtime_resources.auth_key_rotation_lambda.log_group_name}:*"
    ]
  }
}

resource "aws_iam_role_policy" "auth_key_rotation_lambda_runtime" {
  name   = "auth-key-rotation-lambda-runtime-dev"
  role   = module.auth_key_rotation_lambda_role.aws_iam_role_name
  policy = data.aws_iam_policy_document.auth_key_rotation_lambda_runtime.json
}
