/*
 */
variable "network_prefix" {
  description = "Network block for this VPC, without '.0/16'"
  type        = string
}

variable "network_suffix" {
  description = "End of the network CIDR, e.g. '.0/16'"
  type        = string
}

variable "subnet_mask" {
  description = "Netmask for each subnet"
  type        = string
}

variable "subnet_dot_zero" {
  type    = string
  default = ""
}

variable "region" {
  description = "region to deploy to"
  type        = string
}

variable "name" {
  type = string
}
