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
      sid       = config.sid
      effect    = config.effect
      actions   = config.actions
      resources = config.resources
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
