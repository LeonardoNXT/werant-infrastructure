data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = "al2023-ami-2023*"
  }

  owners = [
    "amazon"
  ]
}

resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = var.tags


}
