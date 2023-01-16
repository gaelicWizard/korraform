variable "subnets" {
  description = "Subnets in the VPC"
  type        = map(string)
}

variable "region" {
  description = "region to deploy to"
  type        = string
}

variable "name" {
  type = string
}
