variable "schedule_group_name" {
  description = "Name of the EventBridge Scheduler schedule group"
  type        = string

  validation {
    condition     = can(regex("^[0-9A-Za-z._-]{1,64}$", var.schedule_group_name))
    error_message = "schedule_group_name must contain 1 to 64 alphanumeric, dot, underscore, or hyphen characters."
  }
}

variable "schedules" {
  description = "Schedules keyed by their EventBridge Scheduler name"
  type = map(object({
    description                  = optional(string)
    enabled                      = optional(bool, true)
    execution_role_arn           = string
    maximum_event_age_in_seconds = optional(number, 3600)
    maximum_retry_attempts       = optional(number, 3)
    schedule_expression          = string
    schedule_expression_timezone = optional(string, "UTC")
    target_arn                   = string
    target_input                 = optional(string)
  }))

  validation {
    condition = (
      length(var.schedules) > 0 &&
      alltrue([
        for name, schedule in var.schedules : (
          can(regex("^[0-9A-Za-z._-]{1,64}$", name)) &&
          (schedule.description == null ? true : length(schedule.description) <= 512) &&
          can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:role/.+$", schedule.execution_role_arn)) &&
          floor(schedule.maximum_event_age_in_seconds) == schedule.maximum_event_age_in_seconds &&
          schedule.maximum_event_age_in_seconds >= 60 &&
          schedule.maximum_event_age_in_seconds <= 86400 &&
          floor(schedule.maximum_retry_attempts) == schedule.maximum_retry_attempts &&
          schedule.maximum_retry_attempts >= 0 &&
          schedule.maximum_retry_attempts <= 185 &&
          length(trimspace(schedule.schedule_expression)) > 0 &&
          length(trimspace(schedule.schedule_expression_timezone)) > 0 &&
          can(regex("^arn:aws[a-z-]*:", schedule.target_arn))
        )
      ])
    )
    error_message = "schedules must define valid names, IAM execution roles, target ARNs, expressions, timezones, and retry limits."
  }
}

variable "tags" {
  description = "Tags applied to the EventBridge Scheduler schedule group"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, and ManagedBy values."
  }
}
