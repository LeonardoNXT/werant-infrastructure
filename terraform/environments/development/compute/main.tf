module "application_node" {
  source = "../../../modules/ec2-instance"

  ami_architecture            = "arm64"
  instance_type               = "r6g.large"
  iam_instance_profile_name   = local.identity.application_instance_profile_name
  subnet_id                   = local.network.public_subnet_id
  vpc_security_group_ids      = [local.network.application_security_group_id]
  associate_public_ip_address = true
  root_volume_size_gib        = 30

  tags = merge(local.common_tags, {
    Name     = "werant-dev-application-node"
    Tier     = "Application"
    Workload = "K3sNode"
  })
}
