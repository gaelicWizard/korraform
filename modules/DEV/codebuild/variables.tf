
variable "codebuild_project_name" {
  description = "Name for CodeBuild Project"
}

variable "environment_variables" {
  description = "Environment variables"
  type        = map(string)
}

variable "codebuild_params" {
  description = "Codebuild parameters"
  type        = map(string)
}
