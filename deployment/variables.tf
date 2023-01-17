variable "aws_access_key" {
  description = "Key name"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Key secret"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "The GitHub Token to be used for the CodePipeline"
  type        = string
}
