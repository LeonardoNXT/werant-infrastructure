variable "account_id" {
  description = "AWS account that owns the bucket and KMS key"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a valid 12-digit AWS account ID."
  }
}

variable "bucket_name" {
  description = "Globally unique Development bucket name beginning with werant-dev-"
  type        = string

  validation {
    condition = (
      length(var.bucket_name) <= 63 &&
      can(regex("^werant-dev-[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.bucket_name))
    )
    error_message = "bucket_name must begin with werant-dev-, contain only lowercase letters, numbers, and hyphens, and have at most 63 characters."
  }
}

variable "kms_key_arn" {
  description = "Regional customer-managed KMS key ARN used for default bucket encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:sa-east-1:${var.account_id}:key/[0-9a-f-]+$", var.kms_key_arn))
    error_message = "kms_key_arn must reference a KMS key in account_id and sa-east-1."
  }
}

variable "kms_alias_arn" {
  description = "KMS alias ARN accepted when clients explicitly select the bucket encryption key"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:sa-east-1:${var.account_id}:alias/[A-Za-z0-9/_-]+$", var.kms_alias_arn))
    error_message = "kms_alias_arn must reference a KMS alias in account_id and sa-east-1."
  }
}

variable "lifecycle_rules" {
  description = "Optional lifecycle rules keyed by a stable rule ID"
  type = map(object({
    enabled                                = optional(bool, true)
    prefix                                 = optional(string, "")
    expiration_days                        = optional(number)
    noncurrent_version_expiration_days     = optional(number)
    abort_incomplete_multipart_upload_days = optional(number, 7)
  }))
  default = {}

  validation {
    condition = alltrue([
      for id, rule in var.lifecycle_rules : (
        can(regex("^[A-Za-z0-9_-]{1,255}$", id)) &&
        (rule.expiration_days == null ? true : floor(rule.expiration_days) == rule.expiration_days && rule.expiration_days > 0) &&
        (rule.noncurrent_version_expiration_days == null ? true : floor(rule.noncurrent_version_expiration_days) == rule.noncurrent_version_expiration_days && rule.noncurrent_version_expiration_days > 0) &&
        floor(rule.abort_incomplete_multipart_upload_days) == rule.abort_incomplete_multipart_upload_days &&
        rule.abort_incomplete_multipart_upload_days > 0
      )
    ])
    error_message = "Lifecycle rule IDs must be valid, and all configured day counts must be positive whole numbers."
  }
}

variable "tags" {
  description = "Required Werant Development Storage tags"
  type        = map(string)

  validation {
    condition = (
      lookup(var.tags, "Project", "") == "Werant" &&
      lookup(var.tags, "Environment", "") == "Development" &&
      lookup(var.tags, "Lifecycle", "") == "Storage" &&
      lookup(var.tags, "ManagedBy", "") == "Terraform" &&
      length(trimspace(lookup(var.tags, "Workload", ""))) > 0
    )
    error_message = "tags must set Project=Werant, Environment=Development, Lifecycle=Storage, ManagedBy=Terraform, and a non-empty Workload."
  }
}
