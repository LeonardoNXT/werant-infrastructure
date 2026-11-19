variable "account_id" {
  description = "AWS account that owns the KMS key and its authorized roles"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a valid 12-digit AWS account ID."
  }
}

variable "alias_name" {
  description = "Stable KMS alias beginning with alias/"
  type        = string

  validation {
    condition = (
      can(regex("^alias/[A-Za-z0-9/_-]+$", var.alias_name)) &&
      !startswith(var.alias_name, "alias/aws/") &&
      length(var.alias_name) <= 256
    )
    error_message = "alias_name must be a valid customer-managed KMS alias with at most 256 characters."
  }
}

variable "description" {
  description = "Description of the KMS key purpose"
  type        = string

  validation {
    condition = (
      length(trimspace(var.description)) > 0 &&
      length(var.description) <= 8192
    )
    error_message = "description must contain between 1 and 8192 characters."
  }
}

variable "administrator_role_arns" {
  description = "IAM role ARNs allowed to administer the KMS key"
  type        = set(string)

  validation {
    condition = (
      length(var.administrator_role_arns) > 0 &&
      alltrue([
        for arn in var.administrator_role_arns :
        can(regex("^arn:aws:iam::${var.account_id}:role/.+$", arn))
      ])
    )
    error_message = "administrator_role_arns must contain at least one IAM role ARN from account_id."
  }
}

variable "data_key_generator_role_arns" {
  description = "IAM role ARNs allowed to call GenerateDataKey"
  type        = set(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.data_key_generator_role_arns :
      can(regex("^arn:aws:iam::${var.account_id}:role/.+$", arn))
    ])
    error_message = "data_key_generator_role_arns must contain only IAM role ARNs from account_id."
  }
}

variable "decryptor_role_arns" {
  description = "IAM role ARNs allowed to decrypt data keys"
  type        = set(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.decryptor_role_arns :
      can(regex("^arn:aws:iam::${var.account_id}:role/.+$", arn))
    ])
    error_message = "decryptor_role_arns must contain only IAM role ARNs from account_id."
  }
}

variable "tags" {
  description = "Tags applied to the KMS key"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy", "Workload"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, ManagedBy, and Workload values."
  }
}
