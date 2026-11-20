output "auth_envelope_kms" {
  description = "Identifiers for the Auth envelope encryption KMS key"
  value = {
    alias_arn  = module.auth_envelope_kms.alias_arn
    alias_name = module.auth_envelope_kms.alias_name
    key_arn    = module.auth_envelope_kms.key_arn
    key_id     = module.auth_envelope_kms.key_id
  }
}

output "application_storage_kms" {
  description = "Identifiers for the application storage KMS key"
  value = {
    alias_arn  = module.application_storage_kms.alias_arn
    alias_name = module.application_storage_kms.alias_name
    key_arn    = module.application_storage_kms.key_arn
    key_id     = module.application_storage_kms.key_id
  }
}
