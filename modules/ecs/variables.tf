/*
 */
variable "containers" {
  description = "List of containers to run"
  type        = map(map(string))
}

variable "subnets" {
  description = "Subnets to deploy to"
  type        = list(any)
}

variable "instances" {
  description = "Number of instaces to deploy *each*"
  type        = number
  default     = 1
}

variable "region" {
  description = "region to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "aws_vpc.?.id"
  type        = string
}

/*variable "listener" {
  description = "aws_lb_listener.?.id"
  type        = string
  }/**/

variable "target_groups" {
  description = "aws_lb_target_group.?.*.arn"
  type        = list(string)
}

variable "listener" {
  description = "ARN of the LoadBalancer Listener"
}

variable "project_name" {
  description = "Name to use for these resources"
  type        = string
}

variable "repository_url" {
  description = "URL of the container registry"
  type        = string
}
