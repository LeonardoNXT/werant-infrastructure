
module "aws_federated_provider_oidc" {
  source = "../../../modules/github-oidc-provider"
}

module "aws_network_oidc_role_dev" {
  source           = "../../../modules/github-roles"
  role_name        = "network-github-oidc-role-dev"
  role_description = "Federated IAM role for GitHub Actions to assume the Network deployment role in the Development AWS account."

  federated_oidc_provider_arn = module.aws_federated_provider_oidc.aws_identity_provider_arn
  custom_conditions = {
    "token.actions.githubusercontent.com:sub" : format("repo:%s@%s/%s@%s:environment:%s", local.github.owner_name, local.github.owner_id, local.github.repository_name, local.github.repository_id, local.development.environment_name)
    "token.actions.githubusercontent.com:repository_owner_id" : local.github.owner_id
    "token.actions.githubusercontent.com:repository_id" : local.github.repository_id
    "token.actions.githubusercontent.com:environment" : local.development.environment_name
    "token.actions.githubusercontent.com:ref" : "refs/heads/main"
  }
}

module "aws_network_oidc_policy_dev" {
  source            = "../../../modules/github-oidc-policy"
  oidc_policy_name  = "network-github-oidc-policy-dev"
  target_account_id = local.aws_accounts.development

  oidc_policy_document_sid       = "AllowGithubOidcNetworkDev"
  oidc_policy_description        = "Allows the federated GitHub Actions role to assume the Network deployment role in the Development AWS account."
  oidc_policy_document_role_name = "network-terraform-deploy-role"
}

resource "aws_iam_role_policy_attachment" "network_role_policy_attachment" {
  policy_arn = module.aws_network_oidc_policy_dev.aws_github_oidc_policy_arn
  role       = module.aws_network_oidc_role_dev.aws_iam_role_name
}

module "aws_compute_oidc_role_dev" {
  source           = "../../../modules/github-roles"
  role_name        = "compute-github-oidc-role-dev"
  role_description = "Federated IAM role for GitHub Actions to assume the Compute deployment role in the Development AWS account."

  federated_oidc_provider_arn = module.aws_federated_provider_oidc.aws_identity_provider_arn
  custom_conditions = {
    "token.actions.githubusercontent.com:sub" : format("repo:%s@%s/%s@%s:environment:%s", local.github.owner_name, local.github.owner_id, local.github.repository_name, local.github.repository_id, local.development.environment_name)
    "token.actions.githubusercontent.com:repository_owner_id" : local.github.owner_id
    "token.actions.githubusercontent.com:repository_id" : local.github.repository_id
    "token.actions.githubusercontent.com:environment" : local.development.environment_name
    "token.actions.githubusercontent.com:ref" : "refs/heads/main"
  }
}

module "aws_compute_oidc_policy_dev" {
  source            = "../../../modules/github-oidc-policy"
  oidc_policy_name  = "compute-github-oidc-policy-dev"
  target_account_id = local.aws_accounts.development

  oidc_policy_document_sid       = "AllowGithubOidcComputeDev"
  oidc_policy_description        = "Allows the federated GitHub Actions role to assume the Compute deployment role in the Development AWS account."
  oidc_policy_document_role_name = "compute-terraform-deploy-role"
}

resource "aws_iam_role_policy_attachment" "compute_role_policy_attachment" {
  policy_arn = module.aws_compute_oidc_policy_dev.aws_github_oidc_policy_arn
  role       = module.aws_compute_oidc_role_dev.aws_iam_role_name
}

module "aws_security_oidc_role_dev" {
  source           = "../../../modules/github-roles"
  role_name        = "security-github-oidc-role-dev"
  role_description = "Federated IAM role for GitHub Actions to assume the Security deployment role in the Development AWS account."

  federated_oidc_provider_arn = module.aws_federated_provider_oidc.aws_identity_provider_arn
  custom_conditions = {
    "token.actions.githubusercontent.com:sub" : format("repo:%s@%s/%s@%s:environment:%s", local.github.owner_name, local.github.owner_id, local.github.repository_name, local.github.repository_id, local.development.environment_name)
    "token.actions.githubusercontent.com:repository_owner_id" : local.github.owner_id
    "token.actions.githubusercontent.com:repository_id" : local.github.repository_id
    "token.actions.githubusercontent.com:environment" : local.development.environment_name
    "token.actions.githubusercontent.com:ref" : "refs/heads/main"
  }
}

module "aws_security_oidc_policy_dev" {
  source            = "../../../modules/github-oidc-policy"
  oidc_policy_name  = "security-github-oidc-policy-dev"
  target_account_id = local.aws_accounts.development

  oidc_policy_document_sid       = "AllowGithubOidcSecurityDev"
  oidc_policy_description        = "Allows the federated GitHub Actions role to assume the Security deployment role in the Development AWS account."
  oidc_policy_document_role_name = "security-terraform-deploy-role"
}

resource "aws_iam_role_policy_attachment" "security_role_policy_attachment" {
  policy_arn = module.aws_security_oidc_policy_dev.aws_github_oidc_policy_arn
  role       = module.aws_security_oidc_role_dev.aws_iam_role_name
}

module "aws_storage_oidc_role_dev" {
  source           = "../../../modules/github-roles"
  role_name        = "storage-github-oidc-role-dev"
  role_description = "Federated IAM role for GitHub Actions to assume the Storage deployment role in the Development AWS account."

  federated_oidc_provider_arn = module.aws_federated_provider_oidc.aws_identity_provider_arn
  custom_conditions = {
    "token.actions.githubusercontent.com:sub" : format("repo:%s@%s/%s@%s:environment:%s", local.github.owner_name, local.github.owner_id, local.github.repository_name, local.github.repository_id, local.development.environment_name)
    "token.actions.githubusercontent.com:repository_owner_id" : local.github.owner_id
    "token.actions.githubusercontent.com:repository_id" : local.github.repository_id
    "token.actions.githubusercontent.com:environment" : local.development.environment_name
    "token.actions.githubusercontent.com:ref" : "refs/heads/main"
  }
}

module "aws_storage_oidc_policy_dev" {
  source            = "../../../modules/github-oidc-policy"
  oidc_policy_name  = "storage-github-oidc-policy-dev"
  target_account_id = local.aws_accounts.development

  oidc_policy_document_sid       = "AllowGithubOidcStorageDev"
  oidc_policy_description        = "Allows the federated GitHub Actions role to assume the Storage deployment role in the Development AWS account."
  oidc_policy_document_role_name = "storage-terraform-deploy-role"
}

resource "aws_iam_role_policy_attachment" "storage_role_policy_attachment" {
  policy_arn = module.aws_storage_oidc_policy_dev.aws_github_oidc_policy_arn
  role       = module.aws_storage_oidc_role_dev.aws_iam_role_name
}

module "aws_messaging_oidc_role_dev" {
  source           = "../../../modules/github-roles"
  role_name        = "messaging-github-oidc-role-dev"
  role_description = "Federated IAM role for GitHub Actions to assume the Messaging deployment role in the Development AWS account."

  federated_oidc_provider_arn = module.aws_federated_provider_oidc.aws_identity_provider_arn
  custom_conditions = {
    "token.actions.githubusercontent.com:sub" : format("repo:%s@%s/%s@%s:environment:%s", local.github.owner_name, local.github.owner_id, local.github.repository_name, local.github.repository_id, local.development.environment_name)
    "token.actions.githubusercontent.com:repository_owner_id" : local.github.owner_id
    "token.actions.githubusercontent.com:repository_id" : local.github.repository_id
    "token.actions.githubusercontent.com:environment" : local.development.environment_name
    "token.actions.githubusercontent.com:ref" : "refs/heads/main"
  }
}

module "aws_messaging_oidc_policy_dev" {
  source            = "../../../modules/github-oidc-policy"
  oidc_policy_name  = "messaging-github-oidc-policy-dev"
  target_account_id = local.aws_accounts.development

  oidc_policy_document_sid       = "AllowGithubOidcMessagingDev"
  oidc_policy_description        = "Allows the federated GitHub Actions role to assume the messaging deployment role in the Development AWS account."
  oidc_policy_document_role_name = "messaging-terraform-deploy-role"
}

resource "aws_iam_role_policy_attachment" "messaging_role_policy_attachment" {
  policy_arn = module.aws_messaging_oidc_policy_dev.aws_github_oidc_policy_arn
  role       = module.aws_messaging_oidc_role_dev.aws_iam_role_name
}
