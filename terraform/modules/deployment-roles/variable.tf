
variable "life_cycle_name" {
  type        = string
  description = "Deployment Role resource name"

  validation {
    condition     = length(trimspace(var.life_cycle_name)) > 0
    error_message = "life_cycle_name must not be empty."
  }
}

variable "role_description" {
  type        = string
  description = "Deployment Role description"

  validation {
    condition     = length(trimspace(var.role_description)) > 0
    error_message = "role_description must not be empty."
  }
}

variable "tags" {
  type        = map(string)
  description = "Deployment Role tags"
  default     = {}
}

variable "sid" {
  type        = string
  description = "Deployment Role SID"

  validation {
    condition     = length(trimspace(var.sid)) > 0
    error_message = "sid must not be empty."
  }
}

variable "root_account_id" {
  type        = string
  description = "AWS Management Account ID"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.root_account_id))
    error_message = "root_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "github_oidc_role_name" {
  type        = string
  description = "Federated GitHub OIDC Role name"

  validation {
    condition     = length(trimspace(var.github_oidc_role_name)) > 0
    error_message = "github_oidc_role_name must not be empty."
  }
}
