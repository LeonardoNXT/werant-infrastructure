locals {
  development_account_id = "904054820030"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Compute"
    ManagedBy   = "Terraform"
  }

  bootstrap = {
    flux_manifest_sha256 = "a8c838ccd9be5d30eba9df87cd229b7c4eb80c0049fba1bc3b9840829f267f28"
    flux_version         = "v2.10.0"
    k3s_version          = "v1.36.6+k3s1"
    local_storage_path   = "/var/lib/rancher/k3s/storage"
    node_name            = "werant-development"
  }

  identity = {
    application_instance_profile_name = data.aws_iam_instance_profile.application.name
  }

  network = {
    application_security_group_id = data.aws_security_group.application.id
    public_subnet_id              = data.aws_subnet.public.id
    vpc_id                        = data.aws_vpc.development.id
  }
}
