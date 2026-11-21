variable "ami_architecture" {
  description = "CPU architecture required from the Amazon Linux 2023 AMI"
  type        = string
  default     = "arm64"

  validation {
    condition     = contains(["arm64", "x86_64"], var.ami_architecture)
    error_message = "ami_architecture must be arm64 or x86_64."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string

  validation {
    condition     = length(trimspace(var.instance_type)) > 0
    error_message = "instance_type must not be empty."
  }
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name attached to the EC2 instance"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.iam_instance_profile_name))
    error_message = "iam_instance_profile_name must be a valid IAM instance profile name with at most 128 characters."
  }
}

variable "subnet_id" {
  description = "Subnet where the EC2 instance is created"
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]+$", var.subnet_id))
    error_message = "subnet_id must be a valid subnet ID."
  }
}

variable "vpc_security_group_ids" {
  description = "Security groups attached to the EC2 instance"
  type        = list(string)

  validation {
    condition = (
      length(var.vpc_security_group_ids) > 0 &&
      alltrue([for id in var.vpc_security_group_ids : can(regex("^sg-[0-9a-f]+$", id))])
    )
    error_message = "vpc_security_group_ids must contain at least one valid security group ID."
  }
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IPv4 address"
  type        = bool
  default     = false
}

variable "root_volume_size_gib" {
  description = "Size in GiB of the encrypted gp3 root volume"
  type        = number

  validation {
    condition = (
      var.root_volume_size_gib >= 8 &&
      var.root_volume_size_gib <= 16384 &&
      floor(var.root_volume_size_gib) == var.root_volume_size_gib
    )
    error_message = "root_volume_size_gib must be a whole number between 8 and 16384 GiB."
  }
}

variable "user_data" {
  description = "Optional first-boot configuration consumed by cloud-init"
  type        = string
  default     = null

  validation {
    condition     = var.user_data == null || length(trimspace(var.user_data)) > 0
    error_message = "user_data must be null or a non-empty configuration."
  }
}

variable "tags" {
  description = "EC2 Instance tags"
  type        = map(string)
  default     = {}
}
