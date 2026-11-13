variable "bucket_arn" {
  type        = string
  description = "Terraform Apply bucket arn"

  validation {
    condition     = length(trimspace(var.target_state_key)) > 0
    error_message = "bucket_arn is empty"
  }
}

variable "target_state_key" {
  type        = string
  description = "Terraform Apply target state key"

  validation {
    condition     = length(trimspace(var.target_state_key)) > 0
    error_message = "target_state_key is empty"
  }
}

variable "tags" {
  type        = map(string)
  description = "Terraform Apply tags"
  default     = {}
}
