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

data "archive_file" "auth_key_rotation_bootstrap" {
  type        = "zip"
  source_file = "${path.module}/bootstrap/lambda-placeholder/bootstrap"
  output_path = "${path.root}/.terraform/werant-auth-key-rotation-bootstrap.zip"
}

module "auth_key_rotation_lambda" {
  source = "../../../modules/lambda-function"

  function_name                  = local.auth_key_rotation.function_name
  description                    = "Rotates Werant signing keys through KMS envelope encryption and PostgreSQL lifecycle transitions."
  execution_role_arn             = local.identity.auth_key_rotation_lambda_role_arn
  bootstrap_package_file         = data.archive_file.auth_key_rotation_bootstrap.output_path
  architecture                   = "arm64"
  memory_size                    = 128
  timeout                        = 60
  reserved_concurrent_executions = 1
  alias_name                     = "live"

  environment_variables = {
    AWS_USE_DUALSTACK_ENDPOINT     = "true"
    KMS_KEY_ID                     = local.auth_key_rotation.kms_key_alias
    POSTGRES_CREDENTIALS_PARAMETER = local.auth_key_rotation.postgres_credentials_parameter_name
    POSTGRES_HOST                  = module.application_node.aws_ec2_instance_private_ip
    POSTGRES_PORT                  = tostring(local.auth_key_rotation.postgres_node_port)
    SIGNING_KEY_VERSION            = local.auth_key_rotation.signing_key_version
  }

  vpc_config = {
    ipv6_allowed_for_dual_stack = true
    security_group_ids          = [local.network.auth_key_rotation_security_group_id]
    subnet_ids                  = [local.network.public_subnet_id]
  }

  tags = merge(local.common_tags, {
    Workload = "AuthKeyRotation"
  })
}

module "application_node_power_scheduler" {
  source = "../../../modules/eventbridge-scheduler"

  schedule_group_name = local.scheduler.group_name
  schedules = {
    start_weekdays = {
      description                  = "Start the Development application node at 18:00 from Monday through Friday."
      execution_role_arn           = data.aws_iam_role.ec2_scheduler.arn
      schedule_expression          = "cron(0 18 ? * MON-FRI *)"
      schedule_expression_timezone = local.scheduler.timezone
      target_arn                   = local.scheduler.target_arns.start_instances
      target_input = jsonencode({
        InstanceIds = [module.application_node.aws_ec2_instance_id]
      })
    }

    stop_after_weekdays = {
      description                  = "Stop the Development application node at midnight after each weekday."
      execution_role_arn           = data.aws_iam_role.ec2_scheduler.arn
      schedule_expression          = "cron(0 0 ? * TUE-SAT *)"
      schedule_expression_timezone = local.scheduler.timezone
      target_arn                   = local.scheduler.target_arns.stop_instances
      target_input = jsonencode({
        InstanceIds = [module.application_node.aws_ec2_instance_id]
      })
    }

    start_weekends = {
      description                  = "Start the Development application node at 14:00 on Saturday and Sunday."
      execution_role_arn           = data.aws_iam_role.ec2_scheduler.arn
      schedule_expression          = "cron(0 14 ? * SAT-SUN *)"
      schedule_expression_timezone = local.scheduler.timezone
      target_arn                   = local.scheduler.target_arns.start_instances
      target_input = jsonencode({
        InstanceIds = [module.application_node.aws_ec2_instance_id]
      })
    }

    stop_weekends = {
      description                  = "Stop the Development application node at 23:00 on Saturday and Sunday."
      execution_role_arn           = data.aws_iam_role.ec2_scheduler.arn
      schedule_expression          = "cron(0 23 ? * SAT-SUN *)"
      schedule_expression_timezone = local.scheduler.timezone
      target_arn                   = local.scheduler.target_arns.stop_instances
      target_input = jsonencode({
        InstanceIds = [module.application_node.aws_ec2_instance_id]
      })
    }
  }

  tags = merge(local.common_tags, {
    Workload = "Ec2OperationsScheduler"
  })
}
