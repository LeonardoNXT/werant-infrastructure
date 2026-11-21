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
