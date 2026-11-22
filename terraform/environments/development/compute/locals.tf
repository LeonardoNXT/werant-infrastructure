locals {
  development_account_id = "904054820030"

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Compute"
    ManagedBy   = "Terraform"
  }

  bootstrap = {
    flux_manifest_sha256         = "a8c838ccd9be5d30eba9df87cd229b7c4eb80c0049fba1bc3b9840829f267f28"
    flux_reconciliation_interval = "1m0s"
    flux_reconciliation_timeout  = "5m0s"
    flux_repository_branch       = "main"
    flux_repository_interval     = "1m0s"
    flux_repository_path         = "./clusters/development"
    flux_repository_url          = "https://github.com/LeonardoNXT/werant-platform"
    flux_retry_interval          = "1m0s"
    flux_version                 = "v2.10.0"
    k3s_version                  = "v1.36.6+k3s1"
    local_storage_path           = "/var/lib/rancher/k3s/storage"
    node_name                    = "werant-development"
  }

  identity = {
    application_instance_profile_name = data.aws_iam_instance_profile.application.name
    auth_key_rotation_lambda_role_arn = data.aws_iam_role.auth_key_rotation_lambda.arn
  }

  network = {
    application_security_group_id       = data.aws_security_group.application.id
    auth_key_rotation_security_group_id = data.aws_security_group.auth_key_rotation_lambda.id
    public_subnet_id                    = data.aws_subnet.public.id
    vpc_id                              = data.aws_vpc.development.id
  }

  auth_key_rotation = {
    function_name                  = "werant-auth-key-rotation-dev"
    kms_key_alias                  = "alias/werant-auth-envelope-encryption-dev"
    postgres_node_port             = 30432
    postgres_secret_parameter_name = "/werant/development/auth/postgres"
  }

  scheduler = {
    execution_role_name = "werant-ec2-scheduler-role-dev"
    group_name          = "werant-compute-operations-dev"
    timezone            = "America/Sao_Paulo"

    target_arns = {
      start_instances = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
      stop_instances  = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    }
  }
}
