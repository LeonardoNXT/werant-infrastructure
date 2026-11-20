module "buckets" {
  for_each = var.buckets
  source   = "../../../modules/s3-bucket"

  account_id      = local.development_account_id
  bucket_name     = each.key
  kms_key_arn     = data.aws_kms_alias.application_storage.target_key_arn
  kms_alias_arn   = data.aws_kms_alias.application_storage.arn
  lifecycle_rules = each.value.lifecycle_rules

  tags = merge(local.common_tags, {
    Workload = each.value.workload
  })
}
