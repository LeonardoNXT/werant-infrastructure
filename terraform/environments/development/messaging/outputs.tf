output "auth_key_rotation_scheduler" {
  description = "EventBridge Scheduler group reserved for Auth signing-key rotation"
  value = {
    group_arn  = module.auth_key_rotation_scheduler.schedule_group_arn
    group_name = module.auth_key_rotation_scheduler.schedule_group_name
  }
}
