variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "tags" {
  description = "EC2 Instance tags"
  type        = map(string)
  default     = {}
}
