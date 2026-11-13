variable "policy_name" {
  type        = string
  description = "Deployment policy name"

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "policy_name must not be empty."
  }
}

variable "policy_description" {
  type        = string
  description = "Deployment policy description"
  default     = "Terraform deployment policy"
}


variable "role_statements" {
  description = "Deployment Role statements"
  type = map(object({
    sid       = string
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))

  validation {
    condition = alltrue([
      for _, statement in var.role_statements : (
        length(trimspace(coalesce(statement.sid, ""))) > 0 &&
        contains(["Allow", "Deny"], statement.effect) &&
        length(statement.actions) > 0 &&
        length(statement.resources) > 0
      )
    ])

    error_message = "Each IAM statement must have a non-empty SID, a valid effect (Allow or Deny), and non-empty actions and resources."
  }
}

variable "tags" {
  description = "Deployment Role tags"
  type        = map(string)
  default     = {}
}

