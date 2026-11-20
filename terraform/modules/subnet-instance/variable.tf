variable "vpc_id" {
  description = "ID of the VPC that owns the subnet"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID."
  }
}

variable "availability_zone" {
  description = "Availability Zone where the subnet is created"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}(-[a-z0-9]+)+-[0-9][a-z]$", var.availability_zone))
    error_message = "availability_zone must be a valid AWS Availability Zone name."
  }
}

variable "cidr_block" {
  description = "IPv4 CIDR block assigned to the subnet"
  type        = string

  validation {
    condition = (
      can(cidrnetmask(var.cidr_block)) &&
      try(tonumber(split("/", var.cidr_block)[1]), 0) >= 16 &&
      try(tonumber(split("/", var.cidr_block)[1]), 0) <= 28
    )
    error_message = "cidr_block must be a valid IPv4 CIDR with a prefix between /16 and /28."
  }
}

variable "map_public_ip_on_launch" {
  description = "Whether network interfaces created in the subnet receive public IPv4 addresses by default"
  type        = bool
  default     = false
}

variable "private_dns_hostname_type_on_launch" {
  description = "Hostname type assigned to instances launched in the subnet"
  type        = string
  default     = "resource-name"

  validation {
    condition     = contains(["ip-name", "resource-name"], var.private_dns_hostname_type_on_launch)
    error_message = "private_dns_hostname_type_on_launch must be ip-name or resource-name."
  }
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Whether resource-name hostnames receive DNS A records"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Ownership and workload tags applied to the subnet"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy", "Workload", "Name"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, ManagedBy, Workload, and Name values."
  }
}
