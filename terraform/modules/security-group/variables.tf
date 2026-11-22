variable "name" {
  description = "Name assigned to the Security Group"
  type        = string

  validation {
    condition = (
      length(trimspace(var.name)) > 0 &&
      length(var.name) <= 255 &&
      !startswith(lower(trimspace(var.name)), "sg-")
    )
    error_message = "name must contain between 1 and 255 characters and must not start with sg-."
  }
}

variable "description" {
  description = "Description assigned to the Security Group"
  type        = string

  validation {
    condition = (
      length(trimspace(var.description)) > 0 &&
      length(var.description) <= 255
    )
    error_message = "description must contain between 1 and 255 characters."
  }
}

variable "vpc_id" {
  description = "ID of the VPC that owns the Security Group"
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID."
  }
}

variable "ingress_rules" {
  description = "Ingress rules keyed by a stable Terraform identifier and sourced by exactly one IPv4 CIDR, IPv6 CIDR, or Security Group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    referenced_security_group_id = optional(string)
    description                  = string
    from_port                    = number
    ip_protocol                  = string
    to_port                      = number
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, rule in var.ingress_rules :
      length(trimspace(key)) > 0 &&
      length(compact([
        rule.cidr_ipv4 == null ? "" : rule.cidr_ipv4,
        rule.cidr_ipv6 == null ? "" : rule.cidr_ipv6,
        rule.referenced_security_group_id == null ? "" : rule.referenced_security_group_id
      ])) == 1 &&
      (rule.cidr_ipv4 == null || (can(cidrnetmask(rule.cidr_ipv4)) && !strcontains(rule.cidr_ipv4, ":"))) &&
      (rule.cidr_ipv6 == null || (can(cidrhost(rule.cidr_ipv6, 0)) && strcontains(rule.cidr_ipv6, ":"))) &&
      (rule.referenced_security_group_id == null || can(regex("^sg-([0-9a-f]{8}|[0-9a-f]{17})$", rule.referenced_security_group_id))) &&
      length(trimspace(rule.description)) > 0 &&
      length(rule.description) <= 255 &&
      contains(["-1", "tcp", "udp"], rule.ip_protocol) &&
      (
        rule.ip_protocol == "-1" ?
        rule.from_port == 0 && rule.to_port == 0 :
        rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port
      )
    ])
    error_message = "Each ingress rule must use exactly one valid IPv4 CIDR, IPv6 CIDR, or Security Group ID and define a valid description and protocol range."
  }
}

variable "egress_rules" {
  description = "Egress rules keyed by a stable Terraform identifier and sourced by exactly one IPv4 CIDR, IPv6 CIDR, or Security Group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    referenced_security_group_id = optional(string)
    description                  = string
    from_port                    = number
    ip_protocol                  = string
    to_port                      = number
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, rule in var.egress_rules :
      length(trimspace(key)) > 0 &&
      length(compact([
        rule.cidr_ipv4 == null ? "" : rule.cidr_ipv4,
        rule.cidr_ipv6 == null ? "" : rule.cidr_ipv6,
        rule.referenced_security_group_id == null ? "" : rule.referenced_security_group_id
      ])) == 1 &&
      (rule.cidr_ipv4 == null || (can(cidrnetmask(rule.cidr_ipv4)) && !strcontains(rule.cidr_ipv4, ":"))) &&
      (rule.cidr_ipv6 == null || (can(cidrhost(rule.cidr_ipv6, 0)) && strcontains(rule.cidr_ipv6, ":"))) &&
      (rule.referenced_security_group_id == null || can(regex("^sg-([0-9a-f]{8}|[0-9a-f]{17})$", rule.referenced_security_group_id))) &&
      length(trimspace(rule.description)) > 0 &&
      length(rule.description) <= 255 &&
      contains(["-1", "tcp", "udp"], rule.ip_protocol) &&
      (
        rule.ip_protocol == "-1" ?
        rule.from_port == 0 && rule.to_port == 0 :
        rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port
      )
    ])
    error_message = "Each egress rule must use exactly one valid IPv4 CIDR, IPv6 CIDR, or Security Group ID and define a valid description and protocol range."
  }
}

variable "tags" {
  description = "Ownership and workload tags shared by the Security Group and its rules"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy", "Workload", "Tier"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, ManagedBy, Workload, and Tier values."
  }
}
