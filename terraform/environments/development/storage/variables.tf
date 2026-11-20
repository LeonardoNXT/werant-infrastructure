variable "buckets" {
  description = "Development buckets keyed by their globally unique S3 bucket name"
  type = map(object({
    workload = string
    lifecycle_rules = optional(map(object({
      enabled                                = optional(bool, true)
      prefix                                 = optional(string, "")
      expiration_days                        = optional(number)
      noncurrent_version_expiration_days     = optional(number)
      abort_incomplete_multipart_upload_days = optional(number, 7)
    })), {})
  }))
  default = {}

  validation {
    condition = (
      alltrue([
        for bucket_name, bucket in var.buckets :
        length(bucket_name) <= 63 &&
        can(regex("^werant-dev-[a-z0-9]([a-z0-9-]*[a-z0-9])?$", bucket_name)) &&
        length(trimspace(bucket.workload)) > 0
      ]) &&
      alltrue(flatten([
        for bucket in values(var.buckets) : [
          for rule_id, rule in bucket.lifecycle_rules :
          can(regex("^[A-Za-z0-9_-]{1,255}$", rule_id)) &&
          (rule.expiration_days == null ? true : floor(rule.expiration_days) == rule.expiration_days && rule.expiration_days > 0) &&
          (rule.noncurrent_version_expiration_days == null ? true : floor(rule.noncurrent_version_expiration_days) == rule.noncurrent_version_expiration_days && rule.noncurrent_version_expiration_days > 0) &&
          floor(rule.abort_incomplete_multipart_upload_days) == rule.abort_incomplete_multipart_upload_days &&
          rule.abort_incomplete_multipart_upload_days > 0
        ]
      ]))
    )
    error_message = "Each bucket must use a valid werant-dev-* name, define a non-empty workload, and contain only valid lifecycle rules."
  }
}
