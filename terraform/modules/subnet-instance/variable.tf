variable "vpc_id" {
  description = "Subnet instance vpc id"
  type        = string
}

variable "availability_zone" {
  description = "Subnet instance availability zone"
  type        = string
}

variable "cidr_block" {
  description = "Subnet instance cidr block"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Subnet instance map public ip on launch"
  type        = bool
  default     = false
}

variable "tags" {
  description = "VPC instance tags"
  type        = map(string)
  default     = {}
}
