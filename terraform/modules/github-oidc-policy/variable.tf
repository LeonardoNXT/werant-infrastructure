variable "oidc_policy_document_sid" {
  description = "OIDC policy document instance SID"
  type        = string
}

variable "oidc_policy_document_role_name" {
  description = "OIDC policy document role names"
  type        = string
}

variable "target_account_id" {
  description = "OIDC policy document development account id"
  type        = string
}

variable "oidc_policy_name" {
  description = "OIDC policy name"
  type        = string
}

variable "oidc_policy_description" {
  description = "OIDC policy description"
  type        = string
  default     = ""
}
