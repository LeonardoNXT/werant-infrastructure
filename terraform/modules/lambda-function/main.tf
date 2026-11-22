resource "aws_cloudwatch_log_group" "function" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}

resource "aws_lambda_function" "function" {
  function_name = var.function_name
  description   = var.description
  role          = var.execution_role_arn

  filename         = var.bootstrap_package_file
  source_code_hash = filebase64sha256(var.bootstrap_package_file)
  handler          = var.handler
  runtime          = var.runtime
  architectures    = [var.architecture]

  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = true

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [var.environment_variables] : []

    content {
      variables = environment.value
    }
  }

  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.function]

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }
}

resource "aws_lambda_alias" "deployment" {
  name             = var.alias_name
  description      = "Stable deployment alias for ${var.function_name}"
  function_name    = aws_lambda_function.function.function_name
  function_version = aws_lambda_function.function.version

  lifecycle {
    ignore_changes = [function_version]
  }
}
