variable "project_name" {
  description = "Name to use for this load balancer's resources"
  type        = string
}

variable "certificate" {
  description = "ARN of the TLS certificate"
  type        = string
}

variable "vpc_id" {
  description = "VPC to target"
  type        = string
}

variable "subnets" {
  description = "ARNs of subnets to use"
}
