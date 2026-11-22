module "auth_key_rotation_scheduler" {
  source = "../../../modules/eventbridge-scheduler"

  schedule_group_name = local.key_rotation_scheduler.group_name
  schedules           = {}

  tags = merge(local.common_tags, {
    Workload = "AuthKeyRotation"
  })
}
