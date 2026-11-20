output "application_storage_kms" {
  description = "KMS identifiers resolved from the application Storage alias"
  value = {
    alias_arn = data.aws_kms_alias.application_storage.arn
    key_arn   = data.aws_kms_alias.application_storage.target_key_arn
  }
}

output "buckets" {
  description = "Identifiers and endpoints for the managed Development buckets"
  value = {
    for bucket_name, bucket in module.buckets : bucket_name => {
      arn                  = bucket.bucket_arn
      domain_name          = bucket.bucket_domain_name
      regional_domain_name = bucket.bucket_regional_domain_name
    }
  }
}
