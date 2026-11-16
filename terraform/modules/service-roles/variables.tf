variable "role_name" {
  description = "IAM service role name"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name must be a valid IAM role name with at most 64 characters."
  }
}

variable "role_description" {
  description = "IAM service role description"
  type        = string

  validation {
    condition     = length(trimspace(var.role_description)) > 0
    error_message = "role_description must not be empty."
  }
}

variable "service_principals" {
  description = "AWS service principals allowed to assume the role"
  type        = list(string)

  validation {
    condition = (
      length(var.service_principals) > 0 &&
      alltrue([
        for principal in var.service_principals : endswith(principal, ".amazonaws.com")
      ])
    )
    error_message = "service_principals must contain at least one valid amazonaws.com service principal."
  }
}

variable "sid" {
  description = "Trust policy statement ID"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]+$", var.sid))
    error_message = "sid must contain only alphanumeric characters."
  }
}

variable "tags" {
  description = "IAM service role tags"
  type        = map(string)
  default     = {}
}
