output "auth_key_rotation_lambda_role_arn" {
  description = "Runtime role ARN for the Auth Key Rotation Lambda"
  value       = module.auth_key_rotation_lambda_role.aws_iam_role_arn
}

output "auth_key_rotation_lambda_role_name" {
  description = "Runtime role name for the Auth Key Rotation Lambda"
  value       = module.auth_key_rotation_lambda_role.aws_iam_role_name
}
