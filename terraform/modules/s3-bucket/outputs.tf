output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.bucket.bucket_domain_name
}

output "bucket_id" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_regional_domain_name" {
  description = "Region-specific S3 bucket domain name"
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}
