variable "name" {
  description = "Name of the container"
  type        = string
}

variable "count" {
  description = "Number of instaces to deploy *each*"
  type        = int
}

variable "region" {
  description = "region to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "aws_vpc.?.id"
  type        = string
}

variable "listener" {
  description = "aws_lb_listener.?.id"
  type        = string
}

variable "target_group" {
  description = "aws_lb_target_group.?.*.arn"
  type        = string
}

variable "project" {
  description = "Name to use for these resources"
  type        = string
}