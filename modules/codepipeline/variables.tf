# Repo details

variable "project_name" {
  type = string
}

variable "containers" {

}

variable "ecr_arn" {
  type = string
}

variable "ecr_name" {
  type = string
}

variable "codebuild_arn" {
  description = "ARN of the CodeBuild project to use"
  type        = string
}

variable "codebuild_name" {
  description = "ARN of the CodeBuild project to use"
  type        = string
}

variable "codedeploy_arns" {
  description = "ARN of the CodeDeploy deployment group"
  type        = list(string)
}

variable "codedeploy_app" {
  description = "Name of the CodeDeploy app"
  type        = string
}

variable "codedeploy_group" {
  description = "ARN of the CodeDeploy deployment group"
  type        = string
}

variable "namespace" {
  default = "global"
}

variable "codestar_connection" {
  description = "ARN of KorraHub"
}

variable "region" {
  description = "AWS region to run in"
  type        = string
}
