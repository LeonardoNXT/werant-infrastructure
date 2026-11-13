output "terraform_state_bucket_arn" {
  description = "Centralized Terraform state bucket ARN"
  value       = aws_s3_bucket.terraform_state.arn
}

output "terraform_state_kms_key_arn" {
  description = "KMS key ARN used to encrypt Terraform state"
  value       = aws_kms_key.terraform_state.arn
}
