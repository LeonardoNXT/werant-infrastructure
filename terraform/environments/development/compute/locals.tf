locals {
  development_account_id = "904054820030"
  state_bucket_name      = "werant-tfstate-633697459676"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Compute"
    ManagedBy   = "Terraform"
  }

  identity = {
    application_instance_profile_name = data.terraform_remote_state.identity.outputs.application_ec2_instance_profile_name
  }

  network = {
    application_security_group_id = data.terraform_remote_state.network.outputs.application_security_group_id
    public_subnet_id              = data.terraform_remote_state.network.outputs.public_subnet.id
    vpc_id                        = data.terraform_remote_state.network.outputs.vpc.id
  }
}
