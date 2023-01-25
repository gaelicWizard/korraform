# Repo details

variable "project_name" {
  type = string
}

variable "containers" {

}

variable "codebuild_project_name" {
  description = "Identifier of the CodeBuild project to use"
  type        = string
}

variable "namespace" {
  default = "global"
}

variable "codestar_connection" {
  description = "arn of KorraHub"
}
