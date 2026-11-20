data "aws_kms_alias" "application_storage" {
  name = local.storage_kms_alias_name
}
