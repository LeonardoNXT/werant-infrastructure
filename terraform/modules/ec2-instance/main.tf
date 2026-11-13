data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  owners = [
    "amazon"
  ]
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amzn-linux-2023-ami.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = var.tags
}
