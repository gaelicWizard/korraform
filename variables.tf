# set variables in CLIENT_NAME.TFVARS file
variable "project_name" {
  description = "The name of the client or project"
  type        = string
  default     = ""
}

variable "deployment" {
  description = "GitHub repo and name for each container to build and deploy"
  type        = map(map(string))
  default = {
    Example = {
      repo      = "gaelicWizard/korraform"
      branch    = "main"
      instances = 1
    }
    Repo-3 = {
      repo      = "GitHub-Account-Name/Repo-3-Name"
      branch    = "main"
      instances = 1
    }
    Repo-4 = {
      repo      = "GitHub-Account-Name/Repo-4-Name"
      branch    = "main"
      instances = 1
    }
  }
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

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
