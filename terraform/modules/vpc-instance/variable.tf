variable "cidr_block" {
  description = "Private IPv4 CIDR block assigned to the VPC"
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

variable "assign_generated_ipv6_cidr_block" {
  description = "Whether AWS assigns an Amazon-provided IPv6 CIDR block to the VPC"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Ownership and workload tags applied to the VPC"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy", "Workload", "Name"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, ManagedBy, Workload, and Name values."
  }
}

variable "enable_dns_support" {
  description = "Whether the VPC uses the Amazon-provided DNS server"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether instances with public IP addresses receive DNS hostnames"
  type        = bool
  default     = true
}
