output "application_node" {
  description = "Identifiers and immutable architecture choices for the Development application node"
  value = {
    ami_architecture = "arm64"
    ami_id           = module.application_node.aws_ami_id
    arn              = module.application_node.aws_ec2_instance_arn
    id               = module.application_node.aws_ec2_instance_id
    instance_type    = "r6g.large"
  }
}

output "application_node_power_scheduler" {
  description = "EventBridge Scheduler group reserved for Development application node power operations"
  value = {
    arn  = module.application_node_power_scheduler.schedule_group_arn
    name = module.application_node_power_scheduler.schedule_group_name
  }
}
