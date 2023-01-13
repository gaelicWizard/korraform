variable "container_name" {
	type = string
}

variable "container_group" {
	type = string
}

variable "region" {
  description = "region to deploy to"
  type        = string
}

variable "vpc_id" {
	type = string
}
