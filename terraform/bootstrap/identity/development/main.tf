module "network_deployment_role" {
  source                = "../../../modules/deployment-roles"
  root_account_id       = local.deployment_settings.network.root_account_id
  github_oidc_role_name = local.deployment_settings.network.github_oidc_role_name
  life_cycle_name       = local.deployment_settings.network.life_cycle_name
  sid                   = local.deployment_settings.network.sid
  role_description      = "IAM role assumed by GitHub Actions via OIDC to provision and manage network infrastructure in the Werant Development environment."
}

module "network_deployment_policy" {
  source             = "../../../modules/deployment-policy"
  policy_name        = "AllowNetworkPolicies"
  policy_description = "IAM policy granting the permissions required to provision and manage network subnets through Terraform in the Werant Development environment."
  role_statements = {
    for name, config in local.policies.network :
    name => {
      sid        = config.sid
      effect     = config.effect
      actions    = config.actions
      resources  = config.resources
      conditions = try(config.conditions, [])
    }
  }
}

resource "aws_iam_role_policy_attachment" "network_deployment" {
  policy_arn = module.network_deployment_policy.aws_iam_policy_document_arn
  role       = module.network_deployment_role.aws_iam_role_name
}

module "network_state_access_policy" {
  source = "../../../modules/terraform-apply-policy"

  policy_name      = "network-terraform-state-access-dev"
  bucket_arn       = "arn:aws:s3:::werant-tfstate-${local.aws_accounts.management}"
  target_state_key = "development/network/terraform.tfstate"
  kms_key_arn      = var.terraform_state_kms_key_arn
}

resource "aws_iam_role_policy_attachment" "network_state_access" {
  policy_arn = module.network_state_access_policy.aws_iam_policy_arn
  role       = module.network_deployment_role.aws_iam_role_name
}

module "compute_deployment_role" {
  source                = "../../../modules/deployment-roles"
  root_account_id       = local.deployment_settings.compute.root_account_id
  github_oidc_role_name = local.deployment_settings.compute.github_oidc_role_name
  life_cycle_name       = local.deployment_settings.compute.life_cycle_name
  sid                   = local.deployment_settings.compute.sid
  role_description      = "IAM role assumed by GitHub Actions via OIDC to provision and manage compute infrastructure in the Werant Development environment."
}

module "compute_deployment_policy" {
  source             = "../../../modules/deployment-policy"
  policy_name        = "AllowComputePolicies"
  policy_description = "IAM policy granting the permissions required to discover and manage compute resources through Terraform in the Werant Development environment."
  role_statements = {
    for name, config in local.policies.compute :
    name => {
      sid        = config.sid
      effect     = config.effect
      actions    = config.actions
      resources  = config.resources
      conditions = try(config.conditions, [])
    }
  }
}

resource "aws_iam_role_policy_attachment" "compute_deployment" {
  policy_arn = module.compute_deployment_policy.aws_iam_policy_document_arn
  role       = module.compute_deployment_role.aws_iam_role_name
}

module "compute_state_access_policy" {
  source = "../../../modules/terraform-apply-policy"

  policy_name      = "compute-terraform-state-access-dev"
  bucket_arn       = "arn:aws:s3:::werant-tfstate-${local.aws_accounts.management}"
  target_state_key = "development/compute/terraform.tfstate"
  kms_key_arn      = var.terraform_state_kms_key_arn
}

resource "aws_iam_role_policy_attachment" "compute_state_access" {
  policy_arn = module.compute_state_access_policy.aws_iam_policy_arn
  role       = module.compute_deployment_role.aws_iam_role_name
}

module "security_deployment_role" {
  source                = "../../../modules/deployment-roles"
  root_account_id       = local.deployment_settings.security.root_account_id
  github_oidc_role_name = local.deployment_settings.security.github_oidc_role_name
  life_cycle_name       = local.deployment_settings.security.life_cycle_name
  sid                   = local.deployment_settings.security.sid
  role_description      = "IAM role assumed by GitHub Actions via OIDC to provision and manage security infrastructure in the Werant Development environment."
}

module "security_deployment_policy" {
  source             = "../../../modules/deployment-policy"
  policy_name        = "AllowSecurityPolicies"
  policy_description = "IAM policy granting the permissions required to provision and manage KMS resources through Terraform in the Werant Development environment."
  role_statements = {
    for name, config in local.policies.security :
    name => {
      sid        = config.sid
      effect     = config.effect
      actions    = config.actions
      resources  = config.resources
      conditions = try(config.conditions, [])
    }
  }
}

resource "aws_iam_role_policy_attachment" "security_deployment" {
  policy_arn = module.security_deployment_policy.aws_iam_policy_document_arn
  role       = module.security_deployment_role.aws_iam_role_name
}

module "security_state_access_policy" {
  source = "../../../modules/terraform-apply-policy"

  policy_name      = "security-terraform-state-access-dev"
  bucket_arn       = "arn:aws:s3:::werant-tfstate-${local.aws_accounts.management}"
  target_state_key = "development/security/terraform.tfstate"
  kms_key_arn      = var.terraform_state_kms_key_arn
}

resource "aws_iam_role_policy_attachment" "security_state_access" {
  policy_arn = module.security_state_access_policy.aws_iam_policy_arn
  role       = module.security_deployment_role.aws_iam_role_name
}

module "storage_deployment_role" {
  source                = "../../../modules/deployment-roles"
  root_account_id       = local.deployment_settings.storage.root_account_id
  github_oidc_role_name = local.deployment_settings.storage.github_oidc_role_name
  life_cycle_name       = local.deployment_settings.storage.life_cycle_name
  sid                   = local.deployment_settings.storage.sid
  role_description      = "IAM role assumed by GitHub Actions via OIDC to provision and manage storage infrastructure in the Werant Development environment."
}

module "storage_deployment_policy" {
  source             = "../../../modules/deployment-policy"
  policy_name        = "AllowStoragePolicies"
  policy_description = "IAM policy granting the permissions required to provision and manage S3 buckets through Terraform in the Werant Development environment."
  role_statements = {
    for name, config in local.policies.storage :
    name => {
      sid        = config.sid
      effect     = config.effect
      actions    = config.actions
      resources  = config.resources
      conditions = try(config.conditions, [])
    }
  }
}

resource "aws_iam_role_policy_attachment" "storage_deployment" {
  policy_arn = module.storage_deployment_policy.aws_iam_policy_document_arn
  role       = module.storage_deployment_role.aws_iam_role_name
}

module "storage_state_access_policy" {
  source = "../../../modules/terraform-apply-policy"

  policy_name      = "storage-terraform-state-access-dev"
  bucket_arn       = "arn:aws:s3:::werant-tfstate-${local.aws_accounts.management}"
  target_state_key = "development/storage/terraform.tfstate"
  kms_key_arn      = var.terraform_state_kms_key_arn
}

resource "aws_iam_role_policy_attachment" "storage_state_access" {
  policy_arn = module.storage_state_access_policy.aws_iam_policy_arn
  role       = module.storage_deployment_role.aws_iam_role_name
}

module "auth_key_rotation_lambda_role" {
  source = "../../../modules/service-roles"

  role_name        = "auth-key-rotation-lambda-role-dev"
  role_description = "Runtime identity assumed by the Werant Auth Key Rotation Lambda in the Development environment."
  service_principals = [
    "lambda.amazonaws.com"
  ]
  sid = "AllowLambdaServiceAssumption"

  tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Identity"
    ManagedBy   = "Terraform"
    Workload    = "AuthKeyRotation"
  }
}

module "application_ec2_role" {
  source = "../../../modules/service-roles"

  role_name        = "werant-application-ec2-role-dev"
  role_description = "Runtime identity for the Werant application services hosted on EC2 in the Development environment."
  service_principals = [
    "ec2.amazonaws.com"
  ]
  sid = "AllowEc2ServiceAssumption"

  tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Identity"
    ManagedBy   = "Terraform"
    Workload    = "ApplicationRuntime"
  }
}
