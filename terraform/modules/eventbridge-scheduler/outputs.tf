output "schedule_group_arn" {
  description = "ARN of the EventBridge Scheduler schedule group"
  value       = aws_scheduler_schedule_group.group.arn
}

output "schedule_group_name" {
  description = "Name of the EventBridge Scheduler schedule group"
  value       = aws_scheduler_schedule_group.group.name
}

output "schedule_arns" {
  description = "Schedule ARNs keyed by schedule name"
  value = {
    for name, schedule in aws_scheduler_schedule.schedule :
    name => schedule.arn
  }
}
