variable "terraform_state_kms_key_arn" {
  description = "KMS key ARN exported by terraform/bootstrap/state"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:kms:sa-east-1:633697459676:key/[0-9a-f-]+$", var.terraform_state_kms_key_arn))
    error_message = "terraform_state_kms_key_arn must reference the state KMS key in the management account."
  }
}
