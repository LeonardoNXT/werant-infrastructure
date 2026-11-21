output "auth_key_rotation_lambda_role_arn" {
  description = "Runtime role ARN for the Auth Key Rotation Lambda"
  value       = module.auth_key_rotation_lambda_role.aws_iam_role_arn
}

output "auth_key_rotation_lambda_role_name" {
  description = "Runtime role name for the Auth Key Rotation Lambda"
  value       = module.auth_key_rotation_lambda_role.aws_iam_role_name
}

output "auth_key_rotation_lambda_function_name" {
  description = "Canonical function name for the Auth Key Rotation Lambda"
  value       = local.runtime_resources.auth_key_rotation_lambda.function_name
}

output "auth_key_rotation_lambda_log_group_name" {
  description = "CloudWatch log group name for the Auth Key Rotation Lambda"
  value       = local.runtime_resources.auth_key_rotation_lambda.log_group_name
}

output "application_ec2_role_arn" {
  description = "Runtime role ARN for the Werant application EC2 instance"
  value       = module.application_ec2_role.aws_iam_role_arn
}

output "application_ec2_role_name" {
  description = "Runtime role name for the Werant application EC2 instance"
  value       = module.application_ec2_role.aws_iam_role_name
}

output "application_ec2_instance_profile_arn" {
  description = "Instance profile ARN for the Werant application EC2 instance"
  value       = aws_iam_instance_profile.application.arn
}

output "application_ec2_instance_profile_name" {
  description = "Instance profile name for the Werant application EC2 instance"
  value       = aws_iam_instance_profile.application.name
}

output "ec2_scheduler_role_arn" {
  description = "Runtime role ARN assumed by EventBridge Scheduler for EC2 power operations"
  value       = module.ec2_scheduler_role.aws_iam_role_arn
}

output "ec2_scheduler_role_name" {
  description = "Runtime role name assumed by EventBridge Scheduler for EC2 power operations"
  value       = module.ec2_scheduler_role.aws_iam_role_name
}

output "ec2_scheduler_schedule_group_name" {
  description = "Canonical EventBridge Scheduler group authorized to assume the EC2 scheduler role"
  value       = local.runtime_resources.ec2_scheduler.schedule_group_name
}
