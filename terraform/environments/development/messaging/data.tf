data "aws_iam_role" "auth_key_rotation_scheduler" {
  name = local.key_rotation_scheduler.execution_role_name
}

data "aws_lambda_alias" "auth_key_rotation_live" {
  function_name = local.key_rotation_scheduler.lambda_function_name
  name          = local.key_rotation_scheduler.lambda_alias_name
}
