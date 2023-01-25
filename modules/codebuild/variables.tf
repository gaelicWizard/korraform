/*
 */
variable "project_name" {
  description = "Name for CodeBuild Project"
  type        = string
}

variable "image_name" {
  description = "Name for image"
  type        = string
}

variable "container_repo" {
  description = "URI of the container registry"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables"
  type        = map(string)
}

variable "codebuild_params" {
  description = "Codebuild parameters"
  type        = map(string)
}

variable "region" {
  description = "AWS region to run in"
  type        = string
}
