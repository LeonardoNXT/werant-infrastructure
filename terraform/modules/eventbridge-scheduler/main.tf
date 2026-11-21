resource "aws_scheduler_schedule_group" "group" {
  name = var.schedule_group_name
  tags = var.tags
}

resource "aws_scheduler_schedule" "schedule" {
  for_each = var.schedules

  name                         = each.key
  description                  = each.value.description
  group_name                   = aws_scheduler_schedule_group.group.name
  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = each.value.schedule_expression_timezone
  state                        = each.value.enabled ? "ENABLED" : "DISABLED"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = each.value.target_arn
    input    = each.value.target_input
    role_arn = each.value.execution_role_arn

    retry_policy {
      maximum_event_age_in_seconds = each.value.maximum_event_age_in_seconds
      maximum_retry_attempts       = each.value.maximum_retry_attempts
    }
  }
}
