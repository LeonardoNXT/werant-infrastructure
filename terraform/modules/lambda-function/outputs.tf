output "function_arn" {
  description = "Unqualified Lambda function ARN"
  value       = aws_lambda_function.function.arn
}

output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.function.function_name
}

output "function_version" {
  description = "Published Lambda function version"
  value       = aws_lambda_function.function.version
}

output "alias_arn" {
  description = "Qualified ARN of the stable Lambda alias"
  value       = aws_lambda_alias.deployment.arn
}

output "alias_name" {
  description = "Stable Lambda alias name"
  value       = aws_lambda_alias.deployment.name
}

output "log_group_arn" {
  description = "CloudWatch Logs log group ARN"
  value       = aws_cloudwatch_log_group.function.arn
}

output "log_group_name" {
  description = "CloudWatch Logs log group name"
  value       = aws_cloudwatch_log_group.function.name
}
