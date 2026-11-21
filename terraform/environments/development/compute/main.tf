module "application_node" {
  source = "../../../modules/ec2-instance"

  ami_architecture            = "arm64"
  instance_type               = "r6g.large"
  iam_instance_profile_name   = local.identity.application_instance_profile_name
  subnet_id                   = local.network.public_subnet_id
  vpc_security_group_ids      = [local.network.application_security_group_id]
  associate_public_ip_address = true
  root_volume_size_gib        = 30
  user_data = templatefile("${path.module}/bootstrap/cloud-init.yaml.tftpl", {
    flux_manifest_sha256 = local.bootstrap.flux_manifest_sha256
    flux_version         = local.bootstrap.flux_version
    k3s_version          = local.bootstrap.k3s_version
    local_storage_path   = local.bootstrap.local_storage_path
    node_name            = local.bootstrap.node_name
  })

  tags = merge(local.common_tags, {
    Name     = "werant-dev-application-node"
    Tier     = "Application"
    Workload = "K3sNode"
  })
}
