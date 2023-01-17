variable "project_name" {
  description = "Name to use for this load balancer's resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC to target"
  type        = string
}

variable "subnets" {
  description = "Subnets to use"
}
