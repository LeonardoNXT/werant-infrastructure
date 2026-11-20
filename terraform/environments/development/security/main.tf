module "auth_envelope_kms" {
  source = "../../../modules/kms-key"

  account_id  = local.development_account_id
  alias_name  = "alias/werant-auth-envelope-encryption-dev"
  description = "Envelope encryption key for Werant Auth signing keys in Development"

  administrator_role_arns = [
    local.role_arns.security_deployment
  ]

  data_key_generator_role_arns = [
    local.role_arns.auth_key_rotation_lambda
  ]

  decryptor_role_arns = [
    local.role_arns.application_runtime
  ]

  tags = merge(local.common_tags, {
    Workload = "AuthEnvelopeEncryption"
  })
}

module "application_storage_kms" {
  source = "../../../modules/kms-key"

  account_id  = local.development_account_id
  alias_name  = "alias/werant-storage-dev"
  description = "Encryption key for Werant application object storage in Development"

  administrator_role_arns = [
    local.role_arns.security_deployment
  ]

  tags = merge(local.common_tags, {
    Workload = "ApplicationStorage"
  })
}
