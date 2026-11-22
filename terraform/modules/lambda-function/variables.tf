variable "function_name" {
  description = "Lambda function name"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,64}$", var.function_name))
    error_message = "function_name must be a valid Lambda function name with at most 64 characters."
  }
}

variable "description" {
  description = "Lambda function description"
  type        = string

  validation {
    condition = (
      length(trimspace(var.description)) > 0 &&
      length(var.description) <= 256
    )
    error_message = "description must contain between 1 and 256 characters."
  }
}

variable "execution_role_arn" {
  description = "IAM execution role ARN assumed by the Lambda function"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.execution_role_arn))
    error_message = "execution_role_arn must be a valid IAM role ARN."
  }
}

variable "bootstrap_package_file" {
  description = "Path to the initial Lambda ZIP used only when Terraform creates the function"
  type        = string

  validation {
    condition     = endswith(lower(var.bootstrap_package_file), ".zip")
    error_message = "bootstrap_package_file must reference a ZIP file."
  }
}

variable "handler" {
  description = "Lambda handler name; use bootstrap for Go custom runtimes"
  type        = string
  default     = "bootstrap"

  validation {
    condition     = length(trimspace(var.handler)) > 0
    error_message = "handler must not be empty."
  }
}

variable "runtime" {
  description = "Lambda runtime identifier"
  type        = string
  default     = "provided.al2023"

  validation {
    condition     = length(trimspace(var.runtime)) > 0
    error_message = "runtime must not be empty."
  }
}

variable "architecture" {
  description = "Lambda instruction set architecture"
  type        = string
  default     = "arm64"

  validation {
    condition     = contains(["arm64", "x86_64"], var.architecture)
    error_message = "architecture must be arm64 or x86_64."
  }
}

variable "memory_size" {
  description = "Memory allocated to the Lambda function in MB"
  type        = number
  default     = 128

  validation {
    condition = (
      floor(var.memory_size) == var.memory_size &&
      var.memory_size >= 128 &&
      var.memory_size <= 10240
    )
    error_message = "memory_size must be a whole number between 128 and 10240 MB."
  }
}

variable "timeout" {
  description = "Maximum Lambda execution time in seconds"
  type        = number
  default     = 30

  validation {
    condition = (
      floor(var.timeout) == var.timeout &&
      var.timeout >= 1 &&
      var.timeout <= 900
    )
    error_message = "timeout must be a whole number between 1 and 900 seconds."
  }
}

variable "reserved_concurrent_executions" {
  description = "Maximum concurrent executions reserved for the function; -1 disables the reservation"
  type        = number
  default     = 1

  validation {
    condition = (
      floor(var.reserved_concurrent_executions) == var.reserved_concurrent_executions &&
      var.reserved_concurrent_executions >= -1
    )
    error_message = "reserved_concurrent_executions must be -1 or a non-negative whole number."
  }
}

variable "alias_name" {
  description = "Stable alias pointing to the version published by Terraform"
  type        = string
  default     = "live"

  validation {
    condition = (
      can(regex("^[A-Za-z0-9_-]{1,128}$", var.alias_name)) &&
      !can(regex("^[0-9]+$", var.alias_name)) &&
      var.alias_name != "$LATEST"
    )
    error_message = "alias_name must be a valid non-numeric Lambda alias other than $LATEST."
  }
}

variable "environment_variables" {
  description = "Non-secret environment variables passed to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "log_retention_in_days" {
  description = "CloudWatch Logs retention period in days"
  type        = number
  default     = 30

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180,
      365, 400, 545, 731, 1096, 1827, 2192, 2557,
      2922, 3288, 3653
    ], var.log_retention_in_days)
    error_message = "log_retention_in_days must be a retention period supported by CloudWatch Logs."
  }
}

variable "tags" {
  description = "Tags applied to the Lambda function and its log group"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, and ManagedBy values."
  }
}
