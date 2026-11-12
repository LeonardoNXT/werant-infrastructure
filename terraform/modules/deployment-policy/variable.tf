variable "role_name" {
  type        = string
  description = "Deployment role name"
}

variable "role_description" {
  type    = string
  default = "Deployment role description"
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
      for key, statement in var.statements : (
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

