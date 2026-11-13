variable "instance_type" {
  description = "EC2 instance type"
  type        = string

  validation {
    condition     = length(trimspace(var.instance_type)) > 0
    error_message = "instance_type must not be empty."
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

variable "tags" {
  description = "EC2 Instance tags"
  type        = map(string)
  default     = {}
}
