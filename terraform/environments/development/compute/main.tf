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
    flux_kustomization_manifest_base64 = base64encode(templatefile("${path.module}/bootstrap/flux-kustomization.yaml.tftpl", {
      reconciliation_interval = local.bootstrap.flux_reconciliation_interval
      reconciliation_timeout  = local.bootstrap.flux_reconciliation_timeout
      repository_path         = local.bootstrap.flux_repository_path
      retry_interval          = local.bootstrap.flux_retry_interval
    }))
    flux_manifest_sha256 = local.bootstrap.flux_manifest_sha256
    flux_source_manifest_base64 = base64encode(templatefile("${path.module}/bootstrap/flux-source.yaml.tftpl", {
      repository_branch   = local.bootstrap.flux_repository_branch
      repository_interval = local.bootstrap.flux_repository_interval
      repository_url      = local.bootstrap.flux_repository_url
    }))
    flux_version       = local.bootstrap.flux_version
    k3s_version        = local.bootstrap.k3s_version
    local_storage_path = local.bootstrap.local_storage_path
    node_name          = local.bootstrap.node_name
  })

  tags = merge(local.common_tags, {
    Name     = "werant-dev-application-node"
    Tier     = "Application"
    Workload = "K3sNode"
  })
}
