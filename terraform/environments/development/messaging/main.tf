module "auth_key_rotation_scheduler" {
  source = "../../../modules/eventbridge-scheduler"

  schedule_group_name = local.key_rotation_scheduler.group_name
  schedules = {
    rotate_weekdays = {
      description                  = "Rotate Auth signing keys every 10 minutes while the Development node runs on weekdays."
      enabled                      = false
      execution_role_arn           = data.aws_iam_role.auth_key_rotation_scheduler.arn
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 2
      schedule_expression          = "cron(0/10 18-23 ? * MON-FRI *)"
      schedule_expression_timezone = local.key_rotation_scheduler.timezone
      target_arn                   = data.aws_lambda_alias.auth_key_rotation_live.arn
      target_input                 = jsonencode({})
    }

    rotate_weekends = {
      description                  = "Rotate Auth signing keys every 10 minutes while the Development node runs on weekends."
      enabled                      = false
      execution_role_arn           = data.aws_iam_role.auth_key_rotation_scheduler.arn
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 2
      schedule_expression          = "cron(0/10 14-22 ? * SAT-SUN *)"
      schedule_expression_timezone = local.key_rotation_scheduler.timezone
      target_arn                   = data.aws_lambda_alias.auth_key_rotation_live.arn
      target_input                 = jsonencode({})
    }
  }

  tags = merge(local.common_tags, {
    Workload = "AuthKeyRotation"
  })
}
