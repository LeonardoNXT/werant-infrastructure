variable "bucket_arn" {
  type        = string
  description = "Terraform Apply bucket arn"

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:s3:::[a-z0-9.-]+$", var.bucket_arn))
    error_message = "bucket_arn must be a valid S3 bucket ARN."
  }
}

variable "policy_name" {
  type        = string
  description = "Unique IAM policy name"

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "policy_name must not be empty."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN used to encrypt the Terraform state"

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[0-9a-f-]+$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid KMS key ARN."
  }
}

variable "target_state_key" {
  type        = string
  description = "Terraform Apply target state key"

  validation {
    condition = (
      length(trimspace(var.target_state_key)) > 0 &&
      !startswith(var.target_state_key, "/") &&
      !endswith(var.target_state_key, "/")
    )
    error_message = "target_state_key must be a non-empty S3 object key without leading or trailing slashes."
  }
}

variable "tags" {
  type        = map(string)
  description = "Terraform Apply tags"
  default     = {}
}
