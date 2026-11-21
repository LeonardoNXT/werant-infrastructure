output "arn" {
  description = "ARN of the Security Group"
  value       = aws_security_group.this.arn
}

output "id" {
  description = "ID of the Security Group"
  value       = aws_security_group.this.id
}

output "owner_id" {
  description = "AWS account ID that owns the Security Group"
  value       = aws_security_group.this.owner_id
}

output "ingress_rule_ids" {
  description = "Security Group ingress rule IDs keyed by their input identifiers"
  value = {
    for key, rule in aws_vpc_security_group_ingress_rule.this :
    key => rule.security_group_rule_id
  }
}

output "egress_rule_ids" {
  description = "Security Group egress rule IDs keyed by their input identifiers"
  value = {
    for key, rule in aws_vpc_security_group_egress_rule.this :
    key => rule.security_group_rule_id
  }
}
