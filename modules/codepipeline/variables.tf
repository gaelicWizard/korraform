# Repo details

variable "project_name" {
  type = string
}

variable "containers" {

}

variable "codebuild_name" {
  description = "Identifier of the CodeBuild project to use"
  type        = string
}

variable "codebuild_arn" {
  description = "ARN of the CodeBuild project to use"
  type        = string
}

variable "namespace" {
  default = "global"
}

variable "codestar_connection" {
  description = "arn of KorraHub"
}

variable "region" {
  description = "AWS region to run in"
  type        = string
}
