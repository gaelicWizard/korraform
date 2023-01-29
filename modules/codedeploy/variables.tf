variable "project_name" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "blue_name" {
  type = string
}

variable "green_name" {
  type = string
}

variable "ecs_cluster" {
  type = string
}

variable "ecs_service" {
  type = string
}

variable "listener_arn" {
  type = string
}
