data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-${var.ami_architecture}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [
    "amazon"
  ]
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags        = var.tags
  volume_tags = var.tags
}
