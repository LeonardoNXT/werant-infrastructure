output "aws_ami_id" {
  description = "ID of the Amazon Linux 2023 AMI used by the instance"
  value       = aws_instance.ec2_instance.ami
}

output "aws_ec2_instance_arn" {
  description = "EC2 instance ARN"
  value       = aws_instance.ec2_instance.arn
}

output "aws_ec2_instance_private_ip" {
  description = "Private IPv4 address assigned to the EC2 instance"
  value       = aws_instance.ec2_instance.private_ip
}

output "aws_ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2_instance.id
}
