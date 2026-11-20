variable "vpc_id" {
  description = "ID of the VPC attached to the Internet Gateway"
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID."
  }
}

variable "subnet_id" {
  description = "ID of the subnet associated with the public route table"
  type        = string

  validation {
    condition     = can(regex("^subnet-([0-9a-f]{8}|[0-9a-f]{17})$", var.subnet_id))
    error_message = "subnet_id must be a valid subnet ID."
  }
}

variable "internet_gateway_name" {
  description = "Name tag assigned to the Internet Gateway"
  type        = string

  validation {
    condition = (
      length(trimspace(var.internet_gateway_name)) > 0 &&
      length(var.internet_gateway_name) <= 256
    )
    error_message = "internet_gateway_name must contain between 1 and 256 characters."
  }
}

variable "route_table_name" {
  description = "Name tag assigned to the public route table"
  type        = string

  validation {
    condition = (
      length(trimspace(var.route_table_name)) > 0 &&
      length(var.route_table_name) <= 256
    )
    error_message = "route_table_name must contain between 1 and 256 characters."
  }
}

variable "tags" {
  description = "Ownership and workload tags shared by the routing resources"
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Project", "Environment", "Lifecycle", "ManagedBy", "Workload", "Tier"] :
      contains(keys(var.tags), key) && length(trimspace(lookup(var.tags, key, ""))) > 0
    ])
    error_message = "tags must define non-empty Project, Environment, Lifecycle, ManagedBy, Workload, and Tier values."
  }
}
