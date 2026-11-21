locals {
  development_account_id = "904054820030"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Compute"
    ManagedBy   = "Terraform"
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
