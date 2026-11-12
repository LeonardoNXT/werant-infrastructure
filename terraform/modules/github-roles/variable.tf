variable "role_name" {
  type        = string
  description = "Nome da Role IAM"
}

variable "role_description" {
  type    = string
  default = "IAM role assumed by GitHub Actions via OIDC"
}

variable "federated_oidc_provider_arn" {
  type        = string
  description = "ARN do OpenID Connect Provider do GitHub na AWS"
}

variable "custom_conditions" {
  type    = map(string)
  default = {}
}

variable "tags" {
  description = "Github Terrafrom Instance tags"
  type        = map(string)
  default     = {}
}

