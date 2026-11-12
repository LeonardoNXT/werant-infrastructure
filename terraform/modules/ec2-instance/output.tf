output "aws_ami_id" {
  description = "AMI configuration ARN"
  value       = aws_instance.ec2_instance.ami
}

output "aws_ec2_instance_arn" {
  description = "EC2 instance ARN"
  value       = aws_instance.ec2_instance.arn
}


output "aws_ec2_instance_id" {
  description = "EC2 instance ARN"
  value       = aws_instance.ec2_instance.id
}
