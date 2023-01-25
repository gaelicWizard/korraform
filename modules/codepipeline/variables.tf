# Repo details

variable "project_name" {
  type = string
}

variable "branch_in" {
}

variable "name_in" {
}

# Deployment details

variable "codebuild_project_name" {
  description = "Identifier of the CodeBuild project to use"
  type        = string
}

variable "namespace" {
  default = "global"
}

# S3 Bucket, IAM Role, Codestar Connection

variable "s3_bucket_name" {
}

variable "codestar_connection" {
  description = "arn of KorraHub"
}
