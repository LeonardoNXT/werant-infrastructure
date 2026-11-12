module "aws_federated_provider_oidc" {
  source = "../../../modules/github-oidc"
}

module "aws_network_oidc_role_dev" {
  source           = "../../../modules/github-roles"
  role_name        = "NetworkOidcRoleDev"
  role_description = "Role used to authenticate GitHub Actions OIDC workloads."

  federated_oidc_provider_arn = module.aws_federated_provider_oidc.aws_identity_provider_arn
  custom_conditions = {
    "token.actions.githubusercontent.com:sub" : "repo:LeonardoNXT@170183479/werant-infrastructure@1415053061:environment:development"
    "token.actions.githubusercontent.com:job_workflow_ref" : "LeonardoNXT/werant-infrastructure/.github/workflows/dev/network.yml@refs/heads/main"
  }
}
