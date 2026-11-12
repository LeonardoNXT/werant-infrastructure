variable "cidr_block" {
  description = "VPC instance cidr block"
  type        = string
}

variable "tags" {
  description = "VPC instance tags"
  type        = map(string)
  default     = {}
}

variable "enable_dns_hostnames" {
  description = "VPC instance enable dns hostnames"
  type        = bool
}
