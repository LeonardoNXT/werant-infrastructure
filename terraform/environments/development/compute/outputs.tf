output "application_node" {
  description = "Identifiers and immutable architecture choices for the Development application node"
  value = {
    ami_architecture = "arm64"
    ami_id           = module.application_node.aws_ami_id
    arn              = module.application_node.aws_ec2_instance_arn
    id               = module.application_node.aws_ec2_instance_id
    instance_type    = "r6g.large"
    private_ip       = module.application_node.aws_ec2_instance_private_ip
  }
}

output "application_node_power_scheduler" {
  description = "EventBridge Scheduler resources controlling Development application node power operations"
  value = {
    group_arn     = module.application_node_power_scheduler.schedule_group_arn
    group_name    = module.application_node_power_scheduler.schedule_group_name
    schedule_arns = module.application_node_power_scheduler.schedule_arns
    timezone      = local.scheduler.timezone
  }
}
